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

import AuthenticatorAccountsView
import AuthenticatorCore
import AuthenticatorCoreUI
import AuthenticatorResources
import AuthenticatorSettingsView
@preconcurrency import InAppTwoFactorAuthentication
import InfomaniakConcurrency
@preconcurrency import InfomaniakCore
import InfomaniakDI
import SwiftUI

public struct MainView: View {
    public init() {}

    public var body: some View {
        TabView {
            AccountsView()
                .tabItem {
                    AuthenticatorLabel(\.accountsTitle, iconKey: \.house)
                }

            SettingsView()
                .tabItem {
                    AuthenticatorLabel(\.settingsTitle, iconKey: \.gear)
                }
        }
        .sceneLifecycle(willEnterForeground: willEnterForeground)
    }

    private func willEnterForeground() {
        Task {
            await checkTwoFAChallenges()
        }
    }

    private func checkTwoFAChallenges() async {
        @InjectService var accountManager: AccountManager
        @InjectService var tokenStore: TokenStore

        let tokens = tokenStore.getAllTokens()
        let sessions: [InAppTwoFactorAuthenticationSession] = await tokens.values.asyncCompactMap { account in
            guard let user = await accountManager.userProfileStore.getUserProfile(id: account.userId) else {
                return nil
            }

            let apiFetcher = await accountManager.getApiFetcher(token: account.apiToken)

            return InAppTwoFactorAuthenticationSession(user: user, apiFetcher: apiFetcher)
        }

        @InjectService var inAppTwoFactorAuthenticationManager: InAppTwoFactorAuthenticationManagerable
        inAppTwoFactorAuthenticationManager.checkConnectionAttempts(using: sessions)
    }
}

#Preview {
    MainView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
