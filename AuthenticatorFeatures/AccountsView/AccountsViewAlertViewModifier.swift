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
                mainViewState.accountAlert?.type.title ?? "",
                isPresented: $mainViewState.isShowingAccountAlert
            ) {
                Button(AuthenticatorResourcesStrings.understandConfirmButton, role: .cancel) {
                    mainViewState.accountAlert?.ack()
                    mainViewState.isShowingAccountAlert = false
                }

                Button(AuthenticatorResourcesStrings.notMeButton, role: .destructive) {
                    let currentAlert = mainViewState.accountAlert
                    mainViewState.isShowingAccountAlert = false
                    mainViewState.accountAlertConfirmation = currentAlert
                }
            } message: {
                Text(mainViewState.accountAlert?.type.description(email: mainViewState.accountAlert?.email ?? "") ?? "")
            }
            .alert(
                AuthenticatorResourcesStrings.alertDialogVerifyAccountTitle,
                isPresented: $mainViewState.isShowingAccountAlertConfirmation
            ) {
                Button(AuthenticatorResourcesStrings.alertDialogChangePasswordButton) {
                    closeConfirmationAlert()
                    openURL(URLConstants.recoverPassword.url)
                }
                .keyboardShortcut(.defaultAction)

                Button(AuthenticatorResourcesStrings.alertDialogContactSupportButton) {
                    closeConfirmationAlert()
                    openURL(URLConstants.support.url)
                }

                Button(AuthenticatorResourcesStrings.closeButton, action: closeConfirmationAlert)
                    .keyboardShortcut(.cancelAction)

            } message: {
                Text(AuthenticatorResourcesStrings.accountSecurityVerificationDescription)
            }
    }

    private func closeConfirmationAlert() {
        mainViewState.accountAlertConfirmation?.ack()
        mainViewState.isShowingAccountAlertConfirmation = false
    }
}
