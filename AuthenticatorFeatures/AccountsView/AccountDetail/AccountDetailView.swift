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
import InAppTwoFactorAuthentication
import InfomaniakCore
import InfomaniakDI
import SwiftUI
import CoreAuthenticator

struct AccountDetailView: View {
    @State private var isShowingDisconnectConfirmationAlert = false
    @State private var isShowingDisconnectWarningAlert = false
    @State private var presentedWebViewURL: URL?

    @State private var isFetchingChallenges = false

    let account: UIAccount

    var body: some View {
        List {
            Section {
                Button(action: fetchChallenges) {
                    HStack {
                        Text(AuthenticatorResourcesStrings.refreshPendingLoginsButton)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if isFetchingChallenges {
                            ProgressView()
                        }
                    }
                }
            } header: {
                AccountDetailHeaderView(account: account)
            }
            .headerProminence(.increased)

            Section {
                Button {
                    presentedWebViewURL = URLConstants.accountActivity.url
                } label: {
                    AuthenticatorTrailingLabel(\.activityHistoryButton, iconKey: \.squareArrowDiagonalUp)
                }

                Button {
                    presentedWebViewURL = URLConstants.accountParameters.url
                } label: {
                    AuthenticatorTrailingLabel(\.accountSettingsButton, iconKey: \.squareArrowDiagonalUp)
                }

                Button(AuthenticatorResourcesStrings.disconnectButton, role: .destructive) {
                    isShowingDisconnectWarningAlert = true
                }
            }
        }
        .authListStyle()
        .scrollBounceBehavior(.basedOnSize)
        .autoLoginWebView(protectedURL: $presentedWebViewURL, userId: Int(account.id))
        .alert(AuthenticatorResourcesStrings.disconnectAccountWarningTitle, isPresented: $isShowingDisconnectWarningAlert) {
            Button(AuthenticatorResourcesStrings.checkMyMethodsButton) {
//                CoreAuthenticator.UrlConstants.shared.managerUrl(host: ApiEnvironment.current.host, path: UrlConstants.shared.SETTINGS_MANAGER_URL)
                let host = "staging-authenticator.dev.infomaniak.ch"
                let SETTINGS_2FA_MANAGER_URL = "ng/profile/user/security-and-recovery-parameters/dashboard?global-settings=user-account-security-2fa"
                let urlString = UrlConstants.shared.managerUrl(host: host, path: SETTINGS_2FA_MANAGER_URL)
                guard let url = URL(string: urlString) else {
                    fatalError("Invalid URL")
                }
                presentedWebViewURL = url
            }
                .keyboardShortcut(.defaultAction)

            Button(AuthenticatorResourcesStrings.disconnectAccountTitle, role: .destructive) {
                isShowingDisconnectConfirmationAlert = true
            }

            Button(AuthenticatorResourcesStrings.cancelButton, role: .cancel) {}
        } message: {
            Text(AuthenticatorResourcesStrings.disconnectAccountWarningDescription)
        }
        .alert(AuthenticatorResourcesStrings.disconnectAccountTitle, isPresented: $isShowingDisconnectConfirmationAlert) {
            Button(AuthenticatorResourcesStrings.disconnectAccountTitle, role: .destructive, action: disconnectUser)

            Button(AuthenticatorResourcesStrings.cancelButton, role: .cancel) {}
        } message: {
            Text(AuthenticatorResourcesStrings.disconnectAccountOnThisDeviceDescription)
        }
    }

    private func disconnectUser() {
        Task {
            @InjectService var accountManager: AccountManagerable
            await accountManager.removeAccount(userId: account.id)
        }
    }

    private func fetchChallenges() {
        guard !isFetchingChallenges else { return }
        isFetchingChallenges = true

        Task {
            @InjectService var tokenStore: TokenStore
            @InjectService var accountManager: AccountManagerable

            let userId = TokenStore.UserId(account.id)
            guard let token = tokenStore.tokenFor(userId: userId)?.apiToken,
                  let user = await accountManager.userProfileStore.getUserProfile(id: userId) else {
                isFetchingChallenges = false
                return
            }

            let apiFetcher = await accountManager.getApiFetcher(token: token)

            let session = InAppTwoFactorAuthenticationSession(user: user, apiFetcher: apiFetcher)

            @InjectService var inAppTwoFactorAuthenticationManager: InAppTwoFactorAuthenticationManagerable
            await inAppTwoFactorAuthenticationManager.checkConnectionAttemptsFor(session: session)

            isFetchingChallenges = false
        }
    }
}

#Preview {
    AccountDetailView(account: PreviewHelper.sampleUIAccount)
}
