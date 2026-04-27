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
import SwiftUI

public extension View {
    func loginSheet(isPresented: Binding<Bool>, account: UIAccount) -> some View {
        modifier(LoginSheetViewModifier(isPresented: isPresented, account: account))
    }
}

struct LoginSheetViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    let account: UIAccount

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    LoginView(account: account)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    isPresented = false
                                } label: {
                                    AuthenticatorLabel(\.closeButton, iconKey: \.cross)
                                }
                            }
                        }
                }
                .presentationDragIndicator(.visible)
            }
    }
}
