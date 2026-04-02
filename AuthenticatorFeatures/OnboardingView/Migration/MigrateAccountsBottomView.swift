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
import InfomaniakCore
import InfomaniakCoreSwiftUI
import InfomaniakCoreUIResources
import InfomaniakDI
import SwiftUI

struct MigrateAccountsBottomView: View {
    @State private var accounts: [UIAccount]?
    @State private var isLoading = false
    @State private var isShowingAccountsList = false

    let onStartMigration: () -> Void

    init(onStartMigration: @escaping () -> Void) {
        self.onStartMigration = onStartMigration
    }

    fileprivate init(accounts: [UIAccount]) {
        self.accounts = accounts
        onStartMigration = {}
    }

    var body: some View {
        VStack(spacing: IKPadding.mini) {
            if let accounts,
               !accounts.isEmpty {
                Button {
                    guard accounts.count > 1 else { return }
                    isShowingAccountsList.toggle()
                } label: {
                    if accounts.count == 1,
                       let firstAccount = accounts.first {
                        OneAccountView(account: firstAccount)
                    } else {
                        ManyAccountView(selectedAccounts: accounts)
                    }
                }
                .buttonStyle(.outlined)
                .disabled(isLoading)
            }

            Button(AuthenticatorResourcesStrings.startButton, action: onStartMigration)
                .buttonStyle(.ikBorderedProminent)
                .ikButtonLoading(isLoading)
        }
        .ikButtonFullWidth(true)
        .controlSize(.large)
        .padding(.horizontal, value: .large)
        .task {
            await observeAccountsToMigrate()
        }
        .floatingPanel(
            isPresented: $isShowingAccountsList,
            title: CoreUILocalizable.myAccount(accounts?.count ?? 2),
            backgroundColor: Color(uiColor: .systemBackground)
        ) {
            SelectConnectedAccountListView(connectedAccounts: accounts ?? [])
        }
    }

    private func observeAccountsToMigrate() async {
        guard accounts == nil else { return }

        @InjectService var authenticatorFacade: AuthenticatorFacade
        for try await newAccounts in authenticatorFacade.accounts {
            let newUIAccounts = newAccounts.map { UIAccount(account: $0) }
            withAnimation {
                accounts = newUIAccounts
            }
        }
    }
}

#Preview("Multiple Accounts") {
    MigrateAccountsBottomView(accounts: PreviewHelper.sampleUIAccounts)
}

#Preview("One Account") {
    MigrateAccountsBottomView(accounts: [PreviewHelper.sampleUIAccount])
}
