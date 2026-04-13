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
import AuthenticatorResources
import InfomaniakCoreCommonUI
import InfomaniakDI
import InfomaniakPrivacyManagement
import SwiftUI

public struct SettingsView: View {
    @InjectService private var matomo: MatomoUtils

    @AppStorage(UserDefaults.shared.key(.notificationsEnabled)) private var isNotificationsEnabled = DefaultPreferences
        .notificationsEnabled

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(AuthenticatorResourcesStrings.enableNotifications, isOn: $isNotificationsEnabled)
                    ToggleAppLockSettingsView()
                    NavigationLink(AuthenticatorResourcesStrings.themeTitle) {
                        ChangeThemeSettingsView()
                    }
                }

                Section {
                    NavigationLink(AuthenticatorResourcesStrings.dataManagementTitle) {
                        PrivacyManagementView(
                            urlRepository: URLConstants.githubRepository.url,
                            backgroundColor: .Token.Surface.primary,
                            groupedStyle: true,
                            illustration: AuthenticatorResourcesAsset.Images.privacy.swiftUIImage,
                            userDefaultStore: .shared,
                            userDefaultKeyMatomo: UserDefaults.shared.key(.matomoAuthorized),
                            userDefaultKeySentry: UserDefaults.shared.key(.sentryAuthorized),
                            matomo: matomo
                        )
                    }
                    Link(destination: URL(string: AuthenticatorResourcesStrings.urlUserReport)!) {
                        AuthenticatorTrailingLabel(\.feedbackTitle, iconKey: \.squareArrowDiagonalUp)
                    }
                    Link(destination: URLConstants.support.url) {
                        AuthenticatorTrailingLabel(\.contactSupportTitle, iconKey: \.squareArrowDiagonalUp)
                    }
                }
            }
            .authListStyle()
            .navigationTitle(AuthenticatorResourcesStrings.settingsTitle)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
