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

import AuthenticatorCore
import AuthenticatorResources
import InfomaniakCoreCommonUI
import InfomaniakDI
import SwiftUI

struct ToggleAppLockSettingsView: View {
    @AppStorage(UserDefaults.shared.key(.appLock)) private var isAppLockEnabled: Bool = DefaultPreferences.appLock

    @State private var isProcessingUserAction = false

    var body: some View {
        Toggle(AuthenticatorResourcesStrings.unlockingWithFaceId, isOn: $isAppLockEnabled)
            .onChange(of: isAppLockEnabled) { newValue in
                guard isProcessingUserAction != newValue else { return }
                isProcessingUserAction = newValue
                toggleAppLock()
            }
    }

    private func toggleAppLock() {
        @InjectService var appLockHelper: AppLockHelper

        appLockHelper.setTime()

        Task {
            do {
                if try await !appLockHelper
                    .evaluatePolicy(reason: AuthenticatorResourcesStrings.appSecurityDescription) {
                    didFailToEnableAppLock()
                }
            } catch {
                didFailToEnableAppLock()
            }
        }
    }

    private func didFailToEnableAppLock() {
        isAppLockEnabled.toggle()
        isProcessingUserAction.toggle()
    }
}
