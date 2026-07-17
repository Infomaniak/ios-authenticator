/*
 Infomaniak Authenticator - iOS App
 Copyright (C) 2026 Infomaniak Network SA

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import AppLock
import AuthenticationServices
import AuthenticatorCore
import AuthenticatorCoreUI
import AuthenticatorResources
import DesignSystem
import InfomaniakCoreCommonUI
import InfomaniakCoreUIResources
import InfomaniakCreateAccount
import InfomaniakDI
import InfomaniakLogin
import InfomaniakOnboarding
import InterAppLogin
import SwiftModalPresentation
import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject private var rootViewState: RootViewState

    @State private var shouldShowBiometryStep = !UserDefaults.shared.isAppLockEnabled
    @State private var shouldShowNotificationsStep = true
    @State private var loginHandler = LoginHandler()

    private let currentStep: OnboardingStep
    private var steps: [OnboardingStep] {
        var steps: [OnboardingStep] = []

        switch rootViewState.state {
        case .newAccount:
            steps = OnboardingStep.loginSteps
        case .addAccount:
            steps = OnboardingStep.addAccountSteps
        case .migration:
            steps = OnboardingStep.migrationSteps
        default:
            return []
        }

        if shouldShowBiometryStep {
            steps.append(.biometry)
        }

        if shouldShowNotificationsStep {
            steps.append(.notifications)
        }

        return steps
    }

    private var slides: [Slide] {
        return steps.map { $0.slide }
    }

    private var selectedSlideIndex: Int {
        return steps.firstIndex(of: currentStep) ?? 0
    }

    private var dismissHandler: (@Sendable () -> Void)? {
        guard currentStep == .addAccount else {
            return nil
        }

        return {
            Task { @MainActor in
                rootViewState.cancelAddAccount()
            }
        }
    }

    public init(currentStep: OnboardingStep) {
        self.currentStep = currentStep
    }

    public var body: some View {
        CarouselView(slides: slides, selectedSlide: .constant(selectedSlideIndex), dismissHandler: dismissHandler) { index in
            switch steps[index] {
            case .login, .addAccount:
                OnboardingButtonsView(loginHandler: loginHandler)
                    .matomoView(view: ["OnboardingStart"])
            case .loginInProgress, .migrationInProgress:
                EmptyView()
                    .matomoView(view: ["SecuringAccount"])
            case .migration:
                MigrateAccountsBottomView {
                    goToNextStep(index: index)
                }
                .matomoView(view: ["Migration"])
            case .success:
                Button(AuthenticatorResourcesStrings.continueButton) {
                    goToNextStep(index: index)
                }
                .buttonStyle(.ikBorderedProminent)
                .ikButtonFullWidth(true)
                .controlSize(.large)
                .padding(.horizontal, value: .large)
                .matomoView(view: ["OnboardingComplete"])
            case .biometry:
                VStack {
                    Button(AuthenticatorResourcesStrings.enableButton) {
                        enableBiometry(index: index)
                    }
                    .buttonStyle(.ikBorderedProminent)
                    .ikButtonFullWidth(true)
                    .controlSize(.large)
                    .padding(.horizontal, value: .large)

                    Button(AuthenticatorResourcesStrings.laterButton) {
                        goToNextStep(index: index)
                    }
                    .buttonStyle(.ikBorderless)
                    .ikButtonFullWidth(true)
                    .controlSize(.large)
                    .padding(.horizontal, value: .large)
                }
            case .notifications:
                VStack {
                    Button(AuthenticatorResourcesStrings.onboardingNotificationsAuthorisationButton) {
                        enableNotifications(index: index)
                    }
                    .buttonStyle(.ikBorderedProminent)
                    .ikButtonFullWidth(true)
                    .controlSize(.large)
                    .padding(.horizontal, value: .large)
                }
                .matomoView(view: ["NotificationPermission"])
            }
        }
        .appBackground()
        .ignoresSafeArea()
        .reLoginSheet(account: $rootViewState.mustReLoginAccount)
        .task {
            await checkNotificationAuthorizationStatus()
        }
    }

    private func enableBiometry(index: Int) {
        Task {
            @InjectService var appLockHelper: AppLockHelping
            let enabled = await appLockHelper.canEnableAppLock()

            UserDefaults.shared.isAppLockEnabled = enabled
            goToNextStep(index: index)
        }
    }

    private func enableNotifications(index: Int) {
        Task {
            let center = UNUserNotificationCenter.current()

            guard let isNotificationsEnabled = try? await center.requestAuthorization(options: [.alert, .sound]) else {
                goToNextStep(index: index)
                return
            }

            UserDefaults.shared.isNotificationsEnabled = isNotificationsEnabled
            goToNextStep(index: index)
        }
    }

    private func goToNextStep(index: Int) {
        switch steps[index] {
        case .migration:
            rootViewState.startMigration()
        case .success:
            if shouldShowBiometryStep {
                rootViewState.configureBiometry()
            } else if shouldShowNotificationsStep {
                rootViewState.configureNotifications()
            } else {
                rootViewState.completeOnboarding()
            }
        case .biometry:
            if shouldShowNotificationsStep {
                rootViewState.configureNotifications()
            } else {
                rootViewState.completeOnboarding()
            }
        case .notifications:
            rootViewState.completeOnboarding()
        default:
            // All other cases are handled by KMP
            break
        }
    }

    private func checkNotificationAuthorizationStatus() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        shouldShowNotificationsStep = settings.authorizationStatus == .notDetermined && UserDefaults.shared.isNotificationsEnabled
    }
}

#Preview("Login") {
    OnboardingView(currentStep: .login)
}

#Preview("Progress") {
    OnboardingView(currentStep: .loginInProgress)
}

#Preview("Migration") {
    OnboardingView(currentStep: .migration)
}
