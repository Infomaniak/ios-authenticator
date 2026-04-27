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
import DesignSystem
import InfomaniakCoreCommonUI
import InfomaniakDI
import InfomaniakPrivacyManagement
import SwiftUI

public struct SettingsView: View {
    @InjectService private var matomo: MatomoUtils

    @AppStorage(UserDefaults.shared.key(.notificationsEnabled)) private var isNotificationsEnabled = DefaultPreferences
        .notificationsEnabled

    @State private var isNotificationsAuthorized = true

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
                } header: {
                    if isNotificationsEnabled && !isNotificationsAuthorized {
                        StatusHeaderView(
                            type: .suggestion,
                            description: AuthenticatorResourcesStrings.allowDeviceNotificationsDescription,
                            primaryButton: (
                                title: AuthenticatorResourcesStrings.openSettingsButton,
                                action: openPhoneSettings
                            )
                        )
                        .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.large, trailing: 0))
                    }
                }
                .authSectionStyle()

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
                    .accessibilityHint(AuthenticatorResourcesStrings.contentDescriptionButtonExternalLink)

                    Link(destination: URLConstants.support.url) {
                        AuthenticatorTrailingLabel(\.contactSupportTitle, iconKey: \.squareArrowDiagonalUp)
                    }
                    .accessibilityHint(AuthenticatorResourcesStrings.contentDescriptionButtonExternalLink)
                }
                .authSectionStyle()
            }
            .authListStyle()
            .navigationTitle(AuthenticatorResourcesStrings.settingsTitle)
            .sceneLifecycle(willEnterForeground: willEnterForeground)
        }
    }

    private func willEnterForeground() {
        Task {
            await checkNotificationAuthorization()
        }
    }

    private func checkNotificationAuthorization() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        withAnimation {
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                isNotificationsAuthorized = true
            default:
                isNotificationsAuthorized = false
            }
        }
    }

    private func openPhoneSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(settingsUrl)
    }
}

#Preview {
    SettingsView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
