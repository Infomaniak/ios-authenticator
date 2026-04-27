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
import DesignSystem
@preconcurrency import InAppTwoFactorAuthentication
import InfomaniakConcurrency
import InfomaniakCore
import InfomaniakCoreSwiftUI
import InfomaniakDI
import SwiftUI

public struct AccountsView: View {
    @EnvironmentObject private var mainViewState: MainViewState
    @EnvironmentObject private var rootViewState: RootViewState

    @ScaledMetric(relativeTo: .largeTitle) private var scaledLargeTitle: CGFloat = UIFont.preferredFont(forTextStyle: .largeTitle)
        .pointSize // ⚠️ Reading ScaledMetric at app level breaks app tinting - FB22435372

    public init() {}

    private var shouldDisplayWarning: Bool {
        !mainViewState.accounts.allSatisfy { $0.status == .protected }
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(mainViewState.accounts) { account in
                        AccountsListCell(account: account)
                    }
                } header: {
                    if shouldDisplayWarning {
                        StatusHeaderView(type: .warningList)
                            .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.large, trailing: 0))
                    }
                }
                .authSectionStyle()
            }
            .authListStyle()
            .navigationTitle(Constants.appName)
            .refreshable(action: refreshAccountsList)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: rootViewState.addAccount) {
                        AuthenticatorLabel(\.addAccountButton, iconKey: \.plus)
                    }
                    .primaryActionToolbarButtonStyle()
                }
            }
            .onChange(of: scaledLargeTitle) { newValue in
                setCustomNavigationBarAppearance(fontSize: newValue)
            }
            .onAppear {
                setCustomNavigationBarAppearance(fontSize: scaledLargeTitle)
            }
        }
    }

    private func refreshAccountsList() async {
        @InjectService var accountManager: AccountManagerable
        @InjectService var tokenStore: TokenStore
        @InjectService var inAppTwoFactorAuthenticationManager: InAppTwoFactorAuthenticationManagerable

        let tokens = tokenStore.getAllTokens()
        await tokens.values.asyncForEach { account in
            guard let user = await accountManager.userProfileStore.getUserProfile(id: account.userId) else {
                return
            }

            let apiFetcher = await accountManager.getApiFetcher(token: account.apiToken)

            let session = InAppTwoFactorAuthenticationSession(user: user, apiFetcher: apiFetcher)

            await inAppTwoFactorAuthenticationManager.checkConnectionAttemptsFor(session: session)
        }
    }

    private func setCustomNavigationBarAppearance(fontSize: CGFloat) {
        let smallerLargeTitleAppearance = UINavigationBarAppearance()
        smallerLargeTitleAppearance.largeTitleTextAttributes = [
            .font: UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.boldSystemFont(ofSize: fontSize - 4))
        ]

        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = smallerLargeTitleAppearance
    }
}

#Preview {
    AccountsView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
