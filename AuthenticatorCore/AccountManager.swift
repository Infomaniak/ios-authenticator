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

import Combine
import DeviceAssociation
import Foundation
import InfomaniakCore
import InfomaniakDI
import InfomaniakLogin
import InfomaniakNotifications
import OSLog

public protocol AccountManagerable: Sendable {
    typealias UserId = Int

    var accounts: [ApiToken] { get async }
    var userProfileStore: UserProfileStore { get async }
    var currentSession: Int? { get async }

    func getAccountsIds() async -> [Int]
}

public extension AccountManager {
    enum ErrorDomain: Error {
        case noUserSession
    }
}

public actor AccountManager: AccountManagerable {
    public var accounts: [ApiToken]
    public var userProfileStore: InfomaniakCore.UserProfileStore
    public var currentSession: Int?

    init(accounts: [ApiToken], userProfileStore: InfomaniakCore.UserProfileStore, currentSession: Int?) {
        self.accounts = accounts
        self.userProfileStore = userProfileStore
        self.currentSession = currentSession
    }

    init() {
        self.init(accounts: [], userProfileStore: UserProfileStore(), currentSession: nil)
    }

    public func getAccountsIds() async -> [Int] {
        return accounts.map { $0.userId }
    }
}
