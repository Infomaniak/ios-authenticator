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
import SwiftUI

struct ContactSupportAccountPicker: View {
    @Binding var selection: UIAccount

    let accounts: [UIAccount]

    var body: some View {
        if accounts.count > 1 {
            Picker(AuthenticatorResourcesStrings.accountTitlePlural, selection: $selection) {
                ForEach(accounts) { account in
                    Text(account.email)
                        .tag(account)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .tint(Color.Token.Text.tertiary)
        } else {
            InfoCell(AuthenticatorResourcesStrings.accountTitlePlural, value: selection.email)
        }
    }
}
