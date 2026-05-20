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

import CoreAuthenticator
import InfomaniakDI
import OSLog
import SwiftUI

@MainActor
public final class MainViewState: ObservableObject, @MainActor Equatable {
    @InjectService private var authenticatorFacade: AuthenticatorFacade

    @Published public var selectedAccount: UIAccount?
    @Published public var accounts: [UIAccount]
    @Published public var passwordChangedAccount: UIPasswordChangedAccount?
    @Published public var passwordChangedAccountConfirmation: UIPasswordChangedAccount?

    public var isShowingPasswordChangedAlert: Bool {
        get {
            passwordChangedAccount != nil
        }
        set {
            if !newValue {
                passwordChangedAccount = nil
            }
        }
    }

    public var isShowingPasswordChangedConfirmationAlert: Bool {
        get {
            passwordChangedAccountConfirmation != nil
        }
        set {
            if !newValue {
                passwordChangedAccountConfirmation = nil
            }
        }
    }

    public init(accounts: [UIAccount] = []) {
        self.accounts = accounts
        observeAccounts()
    }

    func observeAccounts() {
        Task {
            for try await newAccounts in authenticatorFacade.accounts {
                let newUIAccounts = newAccounts.map { UIAccount(account: $0) }
                let accountsWithChangedPassword = newAccounts
                    .compactMap {
                        if let status = $0.status as? AccountStatusLoggedIn,
                           let passwordChangedAck = status.passwordChangedAck {
                            return UIPasswordChangedAccount(
                                id: Int($0.id),
                                email: $0.email,
                                passwordChangedAck: passwordChangedAck
                            )
                        } else {
                            return nil
                        }
                    }

                withAnimation {
                    self.accounts = newUIAccounts
                    passwordChangedAccount = accountsWithChangedPassword.first
                }
            }
        }
    }

    public static func == (lhs: MainViewState, rhs: MainViewState) -> Bool {
        return true // TODO: Implement proper equality check based on properties
    }
}
