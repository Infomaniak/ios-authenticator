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
import SwiftUI

struct SubmitTicketView: View {
    @State private var email: String
    @State private var ticket: (subject: String, message: String) = ("", "")

    let accountsEmailsList: [String]

    init(selectedEmail: String? = nil, accountsEmailsList: [String] = []) {
        let startEmail = selectedEmail ?? accountsEmailsList.first ?? ""
        _email = State(initialValue: startEmail)
        self.accountsEmailsList = accountsEmailsList
    }

    var body: some View {
        List {
            Section {
                if accountsEmailsList.isEmpty {
                    TextField(AuthenticatorResourcesStrings.emailPlaceholder, text: $email)
                } else if accountsEmailsList.count > 1 {
                    Picker(AuthenticatorResourcesStrings.accountTitle, selection: $email) {
                        ForEach(accountsEmailsList, id: \.self) { email in
                            Text(email)
                                .tag(email)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .tint(Color.Token.Text.tertiary)
                } else {
                    InfoCell(AuthenticatorResourcesStrings.accountTitle, value: email)
                }

                TextField(AuthenticatorResourcesStrings.subjectPlaceholder, text: $ticket.subject)

                TextField(AuthenticatorResourcesStrings.descriptionPlaceholder, text: $ticket.message, axis: .vertical)
                    .lineLimit(5 ... 10)
            } header: {
                Text(AuthenticatorResourcesStrings.submitTicketDescription)
                    .font(.Token.body)
                    .foregroundStyle(Color.Token.Text.secondary)
                    .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
            }
        }
        .authListStyle()
        .navigationTitle(AuthenticatorResourcesStrings.submitTicketTitle)
        .safeAreaInset(edge: .bottom) {
            SubmitTicketActionView()
                .padding()
        }
    }
}

#Preview("Connected - Multi") {
    NavigationStack {
        SubmitTicketView(accountsEmailsList: PreviewHelper.sampleUIAccounts.map(\.email))
    }
}

#Preview("Connected - Simple") {
    NavigationStack {
        SubmitTicketView(selectedEmail: PreviewHelper.sampleUIAccount.email)
    }
}

#Preview("Not connected") {
    NavigationStack {
        SubmitTicketView(accountsEmailsList: [])
    }
}
