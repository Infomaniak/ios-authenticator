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

import SwiftUI
import AuthenticatorCoreUI
import AuthenticatorResources
import AuthenticatorCore

extension View {
    func accountsViewAlert() -> some View {
        modifier(AccountsViewAlertViewModifier())
    }
}

struct AccountsViewAlertViewModifier: ViewModifier {
    @Environment(\.openURL) private var openURL

    @EnvironmentObject private var mainViewState: MainViewState

    func body(content: Content) -> some View {
        content
            .alert(
                AuthenticatorResourcesStrings.alertDialogPasswordChangedTitle,
                isPresented: $mainViewState.isShowingPasswordChangedAlert
            ) {
                Button(AuthenticatorResourcesStrings.understandConfirmButton, role: .cancel) {
                    mainViewState.passwordChangedAccount?.passwordChangedAck()
                    mainViewState.isShowingPasswordChangedAlert = false
                }

                Button(AuthenticatorResourcesStrings.notMeButton, role: .destructive) {
                    let passwordChangedAccount = mainViewState.passwordChangedAccount
                    mainViewState.isShowingPasswordChangedAlert = false
                    mainViewState.passwordChangedAccountConfirmation = passwordChangedAccount
                }
            } message: {
                Text(AuthenticatorResourcesStrings
                    .alertDialogPasswordChangedText(mainViewState.passwordChangedAccount?.email ?? ""))
            }
            .alert(
                AuthenticatorResourcesStrings.alertDialogVerifyAccountTitle,
                isPresented: $mainViewState.isShowingPasswordChangedConfirmationAlert
            ) {
                Button(AuthenticatorResourcesStrings.alertDialogChangePasswordButton) {
                    mainViewState.passwordChangedAccountConfirmation?.passwordChangedAck()
                    mainViewState.isShowingPasswordChangedAlert = false
                    openURL(URLConstants.recoverPassword.url)
                }
                .keyboardShortcut(.defaultAction)

                Button(AuthenticatorResourcesStrings.alertDialogContactSupportButton) {
                    mainViewState.passwordChangedAccountConfirmation?.passwordChangedAck()
                    mainViewState.isShowingPasswordChangedAlert = false
                    openURL(URLConstants.support.url)
                }

                Button(AuthenticatorResourcesStrings.closeButton) {
                    mainViewState.passwordChangedAccountConfirmation?.passwordChangedAck()
                    mainViewState.isShowingPasswordChangedConfirmationAlert = false
                }
                .keyboardShortcut(.cancelAction)

            } message: {
                Text(AuthenticatorResourcesStrings.accountSecurityVerificationDescription)
            }
    }

}
