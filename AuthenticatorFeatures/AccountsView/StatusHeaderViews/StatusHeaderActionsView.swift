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

import AuthenticatorResources
import DesignSystem
import InfomaniakCoreSwiftUI
import SwiftUI

struct StatusHeaderActionsView: View {
    let type: StatusHeaderView.StatusHeaderType

    var body: some View {
        if type == .errorAccount {
            VStack(spacing: IKPadding.small) {
                Button(AuthenticatorResourcesStrings.contactSupportTitle) {}
                    .font(.Token.bodyBold)
                    .buttonStyle(.ikBordered)

                Button(AuthenticatorResourcesStrings.logInButton, action: login)
                    .buttonStyle(.plain)
            }
            .font(.Token.bodyBold)
            .ikButtonFullWidth(true)
        } else if type == .warningAccount {
            Button(AuthenticatorResourcesStrings.logInButton, action: login)
                .buttonStyle(.ikBordered)
                .ikButtonFullWidth(true)
                .tint(Color.Token.Text.primary)
        }
    }

    private func login() {
        // TODO:
    }
}
