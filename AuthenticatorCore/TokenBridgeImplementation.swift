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
import DeviceAssociation
import Foundation
import InfomaniakCore
import InfomaniakDI
import InfomaniakLogin

final class TokenBridgeImplementation: TokenBridge {
    @LazyInjectService private var tokenStore: TokenStore

    func __getTokenFromCrossAppLogin(userId: Int64) async throws -> String? {
        return nil
    }

    func __getTokenFromDatabase(userId: Int64) async throws -> String? {
        return tokenStore.tokenFor(userId: TokenStore.UserId(userId))?.apiToken.accessToken
    }

    func __persistTokenForAccount(userId: Int64, token: String) async throws {
        tokenStore.removeTokenFor(userId: TokenStore.UserId(userId))

        @InjectService var deviceManager: DeviceManagerable
        let deviceId = try await deviceManager.getOrCreateCurrentDevice().uid

        let apiToken = ApiToken(
            accessToken: token,
            expiresIn: 0,
            refreshToken: nil,
            scope: "",
            tokenType: "",
            userId: Int(userId),
            expirationDate: Date.distantFuture
        )

        tokenStore.addToken(newToken: apiToken, associatedDeviceId: deviceId)
    }
}
