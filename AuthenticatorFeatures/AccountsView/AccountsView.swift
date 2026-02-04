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
import InfomaniakCoreSwiftUI
import SwiftUI

public struct AccountsView: View {
    let accounts: [UIAccount]

    public init(accounts: [UIAccount]) {
        self.accounts = accounts
    }

    public var body: some View {
        NavigationStack {
            List(accounts) { account in
                AccountsListCell(account: account)
            }
            .authListStyle()
            .navigationTitle(Constants.appName)
        }
    }
}

#Preview {
    AccountsView(accounts: PreviewHelper.sampleUIAccounts)
}
