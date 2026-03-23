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
import DesignSystem
import InfomaniakDI
import SwiftUI

struct AccountDetailView: View {
    @State private var isShowingDisconnectConfirmationAlert = false
    @State private var isShowingDisconnectWarningAlert = false

    let account: UIAccount

    var body: some View {
        List {
            Section {
                Button(AuthenticatorResourcesStrings.refreshPendingLoginsButton) {}
            } header: {
                AccountDetailHeaderView(account: account)
            }
            .headerProminence(.increased)

            Section {
                Link(destination: URL(string: "https://www.infomaniak.com/support")!) { // TODO: Replace with correct url
                    AuthenticatorTrailingLabel(\.activityHistoryButton, iconKey: \.squareArrowDiagonalUp)
                }

                Link(destination: URL(string: "https://www.infomaniak.com/support")!) { // TODO: Replace with correct url
                    AuthenticatorTrailingLabel(\.accountSettingsButton, iconKey: \.squareArrowDiagonalUp)
                }

                Button(AuthenticatorResourcesStrings.disconnectButton, role: .destructive) {
                    isShowingDisconnectWarningAlert = true
                }
            }
        }
        .authListStyle()
        .scrollBounceBehavior(.basedOnSize)
        .alert(AuthenticatorResourcesStrings.disconnectAccountWarningTitle, isPresented: $isShowingDisconnectWarningAlert) {
            Button(AuthenticatorResourcesStrings.checkMyMethodsButton) {}
                .keyboardShortcut(.defaultAction)

            Button(AuthenticatorResourcesStrings.disconnectAccountTitle, role: .destructive) {
                isShowingDisconnectConfirmationAlert = true
            }

            Button(AuthenticatorResourcesStrings.cancelButton, role: .cancel) {}
        } message: {
            Text(AuthenticatorResourcesStrings.disconnectAccountWarningDescription)
        }
        .alert(AuthenticatorResourcesStrings.disconnectAccountTitle, isPresented: $isShowingDisconnectConfirmationAlert) {
            Button(AuthenticatorResourcesStrings.disconnectAccountTitle, role: .destructive, action: disconnectUser)

            Button(AuthenticatorResourcesStrings.cancelButton, role: .cancel) {}
        } message: {
            Text(AuthenticatorResourcesStrings.disconnectAccountOnThisDeviceDescription)
        }
    }

    private func disconnectUser() {
        Task {
            @InjectService var accountManager: AccountManagerable
            await accountManager.removeAccount(userId: account.id)
        }
    }
}

#Preview {
    AccountDetailView(account: PreviewHelper.sampleUIAccount)
}
