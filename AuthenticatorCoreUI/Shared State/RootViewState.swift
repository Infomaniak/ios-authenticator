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

@preconcurrency import CoreAuthenticator
import Foundation
import InfomaniakDI
import OSLog
import SwiftUI

@MainActor
public enum OnboardingStep: Equatable {
    case login
    case addAccount
    case migration
    case loginInProgress
    case migrationInProgress
    case success
    case biometry
    case notifications

    public static let loginSteps: [OnboardingStep] = [.login, .loginInProgress, .success]
    public static let addAccountSteps: [OnboardingStep] = [.addAccount, .loginInProgress, .success]
    public static let migrationSteps: [OnboardingStep] = [.migration, .migrationInProgress, .success]
}

@MainActor
public enum RootViewType: @MainActor Equatable {
    public static func == (lhs: RootViewType, rhs: RootViewType) -> Bool {
        switch (lhs, rhs) {
        case (.migration(let lhsOnboardingStep), .migration(let rhsOnboardingStep)):
            return lhsOnboardingStep == rhsOnboardingStep
        case (.newAccount(let lhsOnboardingStep), .newAccount(let rhsOnboardingStep)):
            return lhsOnboardingStep == rhsOnboardingStep
        case (.preloading, .preloading):
            return true
        case (.mainView(let lhsMainViewState), .mainView(let rhsMainViewState)):
            return lhsMainViewState == rhsMainViewState
        case (.updateRequired, .updateRequired):
            return true
        default:
            return false
        }
    }

    case mainView(MainViewState)
    case preloading
    case migration(OnboardingStep)
    case newAccount(OnboardingStep)
    case addAccount(OnboardingStep)
    case updateRequired
}

@MainActor
public final class RootViewState: ObservableObject {
    @InjectService private var authenticatorFacade: AuthenticatorFacade

    private static let logger = Logger(category: "RootViewState")

    @Published public var state: RootViewType = .preloading
    @Published public var mustReLoginAccount: UIMustReLoginAccount?
    private var lastKnownAppStatus: AppStatus?

    public init() {
        observeAppStatus()
    }

    public func startMigration() {
        guard let migrationStatus = lastKnownAppStatus as? AppStatusLoginRequiredMigratingFromLegacyKAuth else {
            return
        }

        migrationStatus.proceed()
    }

    public func configureBiometry() {
        newOnboardingStepFromCurrentState(.biometry)
    }

    public func configureNotifications() {
        newOnboardingStepFromCurrentState(.notifications)
    }

    public func completeOnboarding() {
        guard let onboardingDone = lastKnownAppStatus as? AppStatusEverythingReady else {
            return
        }

        UIApplication.shared.registerForRemoteNotifications()
        onboardingDone.proceed()
    }

    public func addAccount() {
        guard let appStatusSetupComplete = lastKnownAppStatus as? AppStatusSetupComplete else {
            return
        }

        appStatusSetupComplete.addAnAccount()
    }

    public func cancelAddAccount() {
        guard let appStatusAddingAnAccount = lastKnownAppStatus as? AppStatusAddingAnAccount else {
            return
        }

        appStatusAddingAnAccount.cancel()
    }

    func observeAppStatus() {
        Task {
            for try await status in authenticatorFacade.appStatus {
                Self.logger.info("Received new app status: \(String(describing: status))")
                lastKnownAppStatus = status

                mustReLoginAccount = nil

                if status is AppStatusLoginRequiredMigratingFromLegacyKAuth {
                    state = .migration(.migration)
                } else if status is AppStatusLoginRequiredNotMigrating {
                    state = .newAccount(.login)
                } else if status is AppStatusLoggingIn {
                    newOnboardingStepFromCurrentState(.loginInProgress)
                } else if status is AppStatusEverythingReady {
                    newOnboardingStepFromCurrentState(.success)
                } else if status is AppStatusSetupComplete {
                    state = .mainView(MainViewState())
                } else if status is AppStatusAddingAnAccount {
                    state = .newAccount(.addAccount)
                } else if let status = status as? AppStatusLoginRequiredMustReLogin {
                    guard let account = await authenticatorFacade.account(id: status.accountId) else { return }
                    guard let accountStatus = account.status as? AccountStatusNotConnectedReLogin else { return }

                    if mustReLoginAccount == nil {
                        mustReLoginAccount = UIMustReLoginAccount(
                            account: UIAccount(account: account),
                            status: accountStatus,
                            skip: status.skip
                        )
                    }
                }
            }
        }
    }

    func newOnboardingStepFromCurrentState(_ step: OnboardingStep) {
        switch state {
        case .migration:
            state = .migration(step)
        case .newAccount:
            state = .newAccount(step)
        case .addAccount:
            state = .addAccount(step)
        default:
            let currentStateMessage = "Current state: \(String(describing: state))"
            Self.logger
                .warning(
                    "Trying to set \(String(describing: step)) step while not in an onboarding flow. \(currentStateMessage)"
                )
        }
    }
}
