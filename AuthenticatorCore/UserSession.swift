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

public protocol UserSessionable: Sendable {
    var userId: Int { get }
    var apiFetcher: ApiFetcher { get }
}

public struct UserSession: UserSessionable, @unchecked Sendable {
    public let apiFetcher: ApiFetcher
    public let userId: Int

    public init(userId: Int, apiFetcher: ApiFetcher) {
        self.userId = userId
        self.apiFetcher = apiFetcher
    }
}
