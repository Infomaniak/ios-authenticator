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

import CoreAuthenticator
import Foundation
import InfomaniakDI
import SwiftUI

@MainActor
public enum OnboardingStep: Equatable {
    case login
    case migration
    case loginInProgress
    case migrationInProgress
    case success
    case biometry

    public static let loginSteps: [OnboardingStep] = [.login, .loginInProgress, .success]
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
    case updateRequired
}

@MainActor
public final class RootViewState: ObservableObject {
    @InjectService private var authenticatorFacade: AuthenticatorFacade

    @Published public var state: RootViewType = .preloading
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
        state = .newAccount(.biometry)
    }

    public func completeOnboarding() {
        guard let onboardingDone = lastKnownAppStatus as? AppStatusEverythingReady else {
            return
        }

        onboardingDone.proceed()
    }

    func observeAppStatus() {
        Task {
            for try await status in authenticatorFacade.appStatus {
                lastKnownAppStatus = status
                if let loginRequired = status as? AppStatusLoginRequiredMigratingFromLegacyKAuth {
                    state = .migration(.migration)
                } else if let loginRequired = status as? AppStatusLoginRequiredNotMigrating {
                    state = .newAccount(.login)
                } else if let loggingIn = status as? AppStatusLoggingIn {
                    state = .newAccount(.loginInProgress)
                } else if let setupComplete = status as? AppStatusEverythingReady {
                    state = .newAccount(.success)
                } else if let loggedIn = status as? AppStatusSetupComplete {
                    state = .mainView(MainViewState())
                }
            }
        }
    }
}
