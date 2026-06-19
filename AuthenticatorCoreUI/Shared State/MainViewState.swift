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
import SwiftModalPresentation
import SwiftUI

@MainActor
public final class MainViewState: ObservableObject, @MainActor Equatable {
    @InjectService private var authenticatorFacade: AuthenticatorFacade

    @Published public var selectedAccount: UIAccount?
    @Published public var accounts: [UIAccount]
    @Published public var accountAlert: UIAccountAlert?
    @Published public var accountAlertConfirmation: UIAccountAlert?

    @ModalPublished public var isShowingUpdateAvailable = false

    public var isShowingAccountAlert: Bool {
        get {
            accountAlert != nil
        }
        set {
            if !newValue {
                accountAlert = nil
            }
        }
    }

    public var isShowingAccountAlertConfirmation: Bool {
        get {
            accountAlertConfirmation != nil
        }
        set {
            if !newValue {
                accountAlertConfirmation = nil
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
                let accountWithChangedPassword = firstAccountWithChangedPassword(accounts: newAccounts)
                let disconnectedAccount = firstAccountDisconnected(accounts: newAccounts)

                withAnimation {
                    self.accounts = newUIAccounts
                    accountAlert = accountWithChangedPassword ?? disconnectedAccount
                }
            }
        }
    }

    private func firstAccountWithChangedPassword(accounts: [Account]) -> UIAccountAlert? {
        let accountsWithChangedPassword = accounts
            .compactMap {
                if let status = $0.status as? AccountStatusLoggedIn,
                   let passwordChangedAck = status.passwordChangedAck {
                    return UIAccountAlert(
                        id: Int($0.id),
                        email: $0.email,
                        type: .passwordChanged,
                        ack: passwordChangedAck
                    )
                } else {
                    return nil
                }
            }

        return accountsWithChangedPassword.first
    }

    private func firstAccountDisconnected(accounts: [Account]) -> UIAccountAlert? {
        let accountsDisconnected = accounts
            .compactMap {
                if let status = $0.status as? AccountStatusNotConnectedDisconnected {
                    return UIAccountAlert(
                        id: Int($0.id),
                        email: $0.email,
                        type: .disconnected,
                        ack: status.removeAccount
                    )
                } else {
                    return nil
                }
            }

        return accountsDisconnected.first
    }

    public static func == (lhs: MainViewState, rhs: MainViewState) -> Bool {
        if lhs.selectedAccount != rhs.selectedAccount {
            return false
        }

        if lhs.accounts != rhs.accounts {
            return false
        }

        return true
    }
}
