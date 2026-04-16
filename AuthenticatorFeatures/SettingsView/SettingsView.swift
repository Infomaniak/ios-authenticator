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
    @State private var isNotificationsAuthorized = false

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
                        VStack(alignment: .leading) {
                            HStack(spacing: IKPadding.small) {
                                AuthenticatorResourcesAsset.Images.circleInformation.swiftUIImage
                                Text(AuthenticatorResourcesStrings.allowDeviceNotificationsDescription)
                                    .font(.Token.callout)
                                    .foregroundStyle(Color.Token.Text.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            } label: {
                                Text(AuthenticatorResourcesStrings.openSettingsButton)
                                    .foregroundStyle(Color.Token.Text.primary)
                                    .font(.Token.bodyBold)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.ikBordered)
                        }
                        .padding(.vertical, value: .medium)
                        .padding(.horizontal, value: .large)
                        .background(Color.Token.Surface.secondary, in: roundedRectangle)
                        .overlay {
                            roundedRectangle
                                .stroke(Color.Token.Surface.tertiary, lineWidth: 1)
                        }
                        .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
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
            .animation(.smooth, value: isNotificationsEnabled)
            .navigationTitle(AuthenticatorResourcesStrings.settingsTitle)
            .task {
                await checkNotificationAuthorization()
            }
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
        isNotificationsAuthorized = settings.authorizationStatus == .authorized
    }

    private var roundedRectangle: some Shape {
        RoundedRectangle(cornerRadius: 24.0)
    }
}

#Preview {
    SettingsView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
