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

import AuthenticatorCoreUI
import AuthenticatorResources
import DesignSystem
import InfomaniakCore
import InfomaniakCoreSwiftUI
import InfomaniakCoreUIResources
import InfomaniakDI
import SwiftUI

struct OneAccountView: View {
    let account: UIAccount

    var body: some View {
        HStack {
            ConnectedAccountAvatarView(connectedAccount: account)

            VStack(alignment: .leading, spacing: 0) {
                Text(account.name)
                    .font(.Token.headline)
                    .foregroundStyle(Color.Token.Text.primary)
                Text(account.email)
                    .font(.Token.body)
                    .foregroundStyle(Color.Token.Text.secondary)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)

            CenteringPlaceholderAvatarStackView(accounts: [account])
        }
        .padding(.vertical, value: .mini)
    }
}

struct ManyAccountView: View {
    let selectedAccounts: [UIAccount]

    var body: some View {
        HStack(spacing: IKPadding.mini) {
            ConnectedAccountAvatarStackView(accounts: selectedAccounts)

            Text(CoreUILocalizable.myAccount(selectedAccounts.count))
                .font(.Token.headline)
                .frame(maxWidth: .infinity)
                .lineLimit(1)

            CenteringPlaceholderAvatarStackView(accounts: selectedAccounts)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.down")
                        .iconSize(.medium)
                        .foregroundStyle(.tint)
                }
        }
    }
}
