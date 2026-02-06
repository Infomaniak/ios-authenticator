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
import DesignSystem
import SwiftUI

struct AccountDetailHeaderView: View {
    let account: UIAccount

    var body: some View {
        VStack(alignment: .leading, spacing: IKPadding.large) {
            AccountLabel(account: account, size: .large)

            VStack(alignment: .leading) {
                AuthenticatorTrailingLabel(accountStatus: account.status)

                if let description = account.status.description {
                    Text(description)
                        .font(.Token.callout)
                        .foregroundStyle(Color.Token.Text.secondary)
                }
            }
            .padding(.vertical, value: .medium)
            .padding(.horizontal, value: .large)
            .background(Color.Token.Surface.secondary.clipShape(roundedRectangle))
            .overlay {
                roundedRectangle
                    .stroke(Color.Token.Surface.tertiary, lineWidth: 1)
            }
        }
        .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
    }

    private var roundedRectangle: some Shape {
        RoundedRectangle(cornerRadius: 24.0)
    }
}

#Preview {
    AccountDetailHeaderView(account: PreviewHelper.sampleUIAccount)
}
