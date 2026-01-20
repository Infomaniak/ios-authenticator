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
import AuthenticatorCoreUI
import AuthenticatorCore
import AuthenticatorResources
import SwiftUI

public struct SettingsView: View {
    @AppStorage(UserDefaults.shared.key(.notificationsEnabled)) private var isNotificationsEnabled = DefaultPreferences.notificationsEnabled

        public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(AuthenticatorResourcesStrings.enableNotifications, isOn: $isNotificationsEnabled)

                    ToggleAppLockSettingsView()
                }
            }
            .authListStyle()
            .navigationTitle(Constants.appName)
        }
    }
}

#Preview {
    SettingsView()
}
