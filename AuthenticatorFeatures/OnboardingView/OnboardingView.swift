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
    @InjectService private var accountManager: AccountManagerable

    @EnvironmentObject private var rootViewState: RootViewState

    @State private var loginHandler = LoginHandler()
    @State private var excludedUserIds: [Int] = []

    @ModalState(context: ContextKeys.onboarding) private var isPresentingCreateAccount = false

    private let currentStep: OnboardingStep
    private var steps: [OnboardingStep] {
        if let cached = rootViewState.cachedOnboardingSteps {
            return cached
        }

        var steps: [OnboardingStep] = []

        switch rootViewState.state {
        case .newAccount:
            steps = OnboardingStep.loginSteps
        case .addAccount:
            steps = OnboardingStep.addAccountSteps
        case .migration:
            return OnboardingStep.migrationSteps
        default:
            return []
        }

        if !UserDefaults.shared.isAppLockEnabled {
            steps.append(.biometry)
        }

        if rootViewState.shouldShowNotificationsStep {
            steps.append(.notifications)
        }

        rootViewState.cachedOnboardingSteps = steps
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
                ContinueWithAccountView(isLoading: loginHandler.isLoading, excludingUserIds: excludedUserIds) {
                    login()
                } onLoginWithAccountsPressed: { accounts in
                    login(with: accounts)
                } onCreateAccountPressed: {
                    isPresentingCreateAccount = true
                }
                .ikButtonFullWidth(true)
                .environment(\.outlinedButtonBackgroundColor, Color.Token.Surface.outlined)
                .controlSize(.large)
                .padding(.horizontal, value: .large)
            case .loginInProgress, .migrationInProgress:
                EmptyView()
            case .migration:
                MigrateAccountsBottomView {
                    goToNextStep(index: index)
                }
            case .success:
                Button(AuthenticatorResourcesStrings.continueButton) {
                    goToNextStep(index: index)
                }
                .buttonStyle(.ikBorderedProminent)
                .ikButtonFullWidth(true)
                .controlSize(.large)
                .padding(.horizontal, value: .large)
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
                    Button(AuthenticatorResourcesStrings.enableButton) {
                        enableNotifications(index: index)
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
            }
        }
        .id(excludedUserIds)
        .appBackground()
        .ignoresSafeArea()
        .sheet(isPresented: $isPresentingCreateAccount) {
            RegisterView(registrationProcess: .mail) { viewController in // TODO: Change with his own registration process
                guard let viewController else { return }
                loginHandler.loginAfterAccountCreation(from: viewController)
            }
        }
        .task {
            loginHandler.isLoading = true
            excludedUserIds = await accountManager.getAccountsIds()
            loginHandler.isLoading = false
        }
    }

    private func login(with accounts: [ConnectedAccount] = []) {
        Task {
            if accounts.isEmpty {
                await loginHandler.login()
            } else {
                await loginHandler.login(with: accounts)
            }
        }
    }

    private func enableBiometry(index: Int) {
        Task {
            @InjectService var appLockHelper: AppLockHelper
            let enabled = await appLockHelper.canEnableAppLock()

            UserDefaults.shared.isAppLockEnabled = enabled
            goToNextStep(index: index)
        }
    }

    private func enableNotifications(index: Int) {
        Task {
            let center = UNUserNotificationCenter.current()

            guard let isNotificationsEnabled =
                try? await center.requestAuthorization(options: [.alert, .sound]) else {
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
            if !UserDefaults.shared.isAppLockEnabled {
                rootViewState.configureBiometry()
            } else if rootViewState.shouldShowNotificationsStep {
                rootViewState.configureNotifications()
            } else {
                rootViewState.completeOnboarding()
            }
        case .biometry:
            if rootViewState.shouldShowNotificationsStep {
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
