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
import CoreAuthenticator
import InfomaniakDI
import SwiftUI

public extension View {
    func reLoginSheet(account: Binding<UIMustReLoginAccount?>) -> some View {
        modifier(ReLoginSheetViewModifier(account: account))
    }
}

struct ReLoginSheetViewModifier: ViewModifier {
    @InjectService private var authenticatorFacade: AuthenticatorFacade

    @Binding var account: UIMustReLoginAccount?

    func body(content: Content) -> some View {
        content
            .sheet(item: $account) { account in
                NavigationStack {
                    LoginView(account: account)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    account.skip()
                                    self.account = nil
                                } label: {
                                    AuthenticatorLabel(\.closeButton, iconKey: \.cross)
                                }
                            }
                        }
                }
                .presentationDragIndicator(.visible)
            }
            .task(id: account?.id) {
                await observeAccountStatus()
            }
    }

    func observeAccountStatus() async {
        guard let accountId = account?.id else { return }

        for await accounts in authenticatorFacade.accounts {
            guard let account = accounts.first(where: { $0.id == accountId }),
                  let accountStatus = account.status as? AccountStatusNotConnectedReLogin else { return }

            self.account?.status = accountStatus
        }
    }
}
