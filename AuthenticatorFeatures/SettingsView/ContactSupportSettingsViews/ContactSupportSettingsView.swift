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
import InfomaniakCoreCommonUI
import InfomaniakCoreSwiftUI
import SwiftUI

struct ContactSupportSettingsView: View {
    @State private var selectedAccount: UIAccount?
    @State private var authorizationCode: String?
    @State private var waitTime: TimeInterval = 0

    let accounts: [UIAccount]

    init(selectedAccount: UIAccount? = nil, accounts: [UIAccount]) {
        self.selectedAccount = selectedAccount ?? accounts.first
        self.accounts = accounts
    }

    var body: some View {
        List {
            Section {
                if let selectedAccount = Binding($selectedAccount) {
                    ContactSupportAccountPicker(selection: selectedAccount, accounts: accounts)
                }

                if let authorizationCode {
                    InfoCell(AuthenticatorResourcesStrings.authorizationCodeTitle, value: authorizationCode)
                }
            } header: {
                ContactSupportSettingsHeaderView()
                    .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
            }
            .headerProminence(.increased)
        }
        .authListStyle()
        .navigationTitle(AuthenticatorResourcesStrings.contactSupportTitle)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            ContactSupportActionsView(
                selectedAccount: $selectedAccount,
                accountsEmailsList: accounts.map(\.email),
                waitTime: waitTime
            )
            .padding()
        }
        .task {
            waitTime = 1200 // TODO: Fetch real wait time from API
            authorizationCode = getAuthorisationCode() // TODO: Fetch real code time from API
        }
    }

    private func getAuthorisationCode() -> String? {
        return "12345" // TODO: Fetch real one from API
    }
}

#Preview {
    NavigationStack {
        ContactSupportSettingsView(accounts: PreviewHelper.sampleUIAccounts)
            .tint(.Token.primary)
    }
}
