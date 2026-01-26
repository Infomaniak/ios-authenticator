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
import InfomaniakCoreSwiftUI
import SwiftUI

public struct AccountsView: View {
    @EnvironmentObject private var mainViewState: MainViewState

    public init() {}

    public var body: some View {
        NavigationStack {
            List(mainViewState.accountsManager.accounts, selection: $mainViewState.accountsManager.selectedAccount) { account in
                AccountsListCell(account: account)
                    .tag(account)
            }
            .authListStyle()
            .navigationTitle(Constants.appName)
            .refreshable(action: refreshAccountsList)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // TODO: Add an account
                    } label: {
                        AuthenticatorLabel(\.addAccountButton, iconKey: \.plus)
                    }
                }
            }
        }
    }

    private func refreshAccountsList() {
        // TODO: Refresh accounts list
    }
}

#Preview {
    AccountsView()
        .environmentObject(PreviewHelper.sampleMainViewState)
}
