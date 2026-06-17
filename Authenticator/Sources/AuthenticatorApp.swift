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
import AuthenticatorCore
import AuthenticatorCoreUI
import AuthenticatorResources
import AuthenticatorRootView
import InfomaniakCoreCommonUI
import InfomaniakDI
import OSLog
import SwiftUI
import VersionChecker

@main
struct AuthenticatorApp: App {
    // periphery:ignore - Making sure the Sentry is initialized at a very early stage of the app launch.
    private let sentryService = SentryService()
    // periphery:ignore - Making sure the DI is registered at a very early stage of the app launch.
    private let dependencyInjectionHook = AuthenticatorAppTargetAssembly()

    @LazyInjectService var appLockHelper: AppLockHelping

    @AppStorage(UserDefaults.shared.key(.theme), store: .shared) private var theme = DefaultPreferences.theme

    @UIApplicationDelegateAdaptor private var appDelegateAdaptor: AppDelegate

    @StateObject private var rootViewState = RootViewState()
    @State private var versionCheckTask: Task<Void, Never>?

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootViewState)
                .preferredColorScheme(theme.asColorScheme)
                .sceneLifecycle(willEnterForeground: willEnterForeground, didEnterBackground: didEnterBackground)
        }
        .defaultAppStorage(.shared)
    }

    private func willEnterForeground() {
        appLockHelper.startObservation()
        checkAppVersion()
    }

    private func didEnterBackground() {
        if UserDefaults.shared.isAppLockEnabled {
            appLockHelper.setTime()
        }
    }

    private func checkAppVersion() {
        versionCheckTask?.cancel()

        versionCheckTask = Task {
            do {
                let versionStatus = try await VersionChecker.standard.checkAppVersionStatus(platform: .ios)
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    if versionStatus == .updateIsRequired {
                        rootViewState.enterUpdateRequired()
                        return
                    }

                    if rootViewState.state == .updateRequired {
                        rootViewState.exitUpdateRequired()
                        return
                    }

                    if versionStatus == .canBeUpdated,
                       case .mainView(let mainViewState) = rootViewState.state {
                        mainViewState.isShowingUpdateAvailable = true
                    }
                }
            } catch is CancellationError {
                // Ignore cancellation
            } catch {
                Logger.general.error("Error while checking version status: \(error)")
            }
        }
    }
}
