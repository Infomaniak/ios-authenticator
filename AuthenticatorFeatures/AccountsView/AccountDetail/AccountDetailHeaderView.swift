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
import CoreAuthenticator
import DesignSystem
import InfomaniakDI
import SwiftUI

struct AccountDetailHeaderView: View {
    @Environment(\.openURL) private var openURL

    @State private var presentedWebViewUrl: URL?
    @State private var mustReloginAccount: UIMustReLoginAccount?

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

                if account.status == .partiallyProtected {
                    Button {
                        presentedWebViewUrl = URLConstants.accountParameters.url
                    } label: {
                        Text(AuthenticatorResources.AuthenticatorResourcesStrings.updateButton)
                            .foregroundStyle(Color.Token.Text.primary)
                            .font(.Token.bodyBold)
                    }
                    .buttonStyle(.ikBordered)
                    .ikButtonFullWidth(true)
                }
            }
            .padding(.vertical, value: .medium)
            .padding(.horizontal, value: .large)
            .background(Color.Token.Surface.secondary, in: roundedRectangle)
            .overlay {
                roundedRectangle
                    .stroke(Color.Token.Surface.tertiary, lineWidth: 1)
            }
            .autoLoginWebView(protectedURL: $presentedWebViewUrl, userId: Int(account.id))

            if account.status == .loggedOut {
                StatusHeaderView(
                    type: .warning,
                    description: AuthenticatorResourcesStrings.errorLoginFailed,
                    primaryButton: (title: AuthenticatorResourcesStrings.logInButton, action: loginAccountTapped),
                    secondaryButton: (
                        title: AuthenticatorResourcesStrings.contactSupportTitle,
                        action: { openURL(URLConstants.support.url) }
                    )
                )
            }
        }
        .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
        .reLoginSheet(account: $mustReloginAccount)
    }

    private var roundedRectangle: some Shape {
        RoundedRectangle(cornerRadius: 24.0)
    }

    private func loginAccountTapped() {
        Task {
            @InjectService var authenticatorFacade: AuthenticatorFacade
            guard let account = await authenticatorFacade.account(id: account.id) else { return }
            guard let accountStatus = account.status as? AccountStatusNotConnectedReLogin else { return }

            mustReloginAccount = UIMustReLoginAccount(
                account: UIAccount(account: account),
                status: accountStatus,
                skip: nil
            )
        }
    }
}

#Preview {
    AccountDetailHeaderView(account: PreviewHelper.sampleUIAccount)
}

#Preview {
    AccountDetailHeaderView(account: PreviewHelper.sampleUIAccount2)
}

#Preview {
    AccountDetailHeaderView(account: PreviewHelper.sampleUIAccount3)
}
