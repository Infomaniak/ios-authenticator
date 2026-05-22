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
import InterAppLogin

final class TokenBridgeImplementation: AuthenticatorBridge {
    @LazyInjectService private var tokenStore: TokenStore
    @LazyInjectService private var connectedAccountManager: ConnectedAccountManagerable
    @LazyInjectService private var networkLogin: InfomaniakNetworkLoginable
    @LazyInjectService private var accountManager: AccountManagerable

    func __getTokenFromCrossAppLogin(userId: Int64) async -> SharedApiToken? {
        let connectedAccounts = await connectedAccountManager.listAllLocalAccounts()

        guard let matchingConnectedAccount = connectedAccounts.first(where: { $0.userId == userId }) else {
            return nil
        }

        do {
            let derivedToken = try await networkLogin.derivateApiToken(
                for: matchingConnectedAccount,
                appBundleId: Constants.bundleId
            )

            return SharedApiToken(from: derivedToken)
        } catch {
            SentryDebug.loginError(error: error, step: "createAndSetCurrentAccount")
            return nil
        }
    }

    func __persistUserProfile(userProfile: SharedUserProfile) async throws {
        let localUserProfile = UserProfile(from: userProfile)
        try await __persistTokenForAccount(userId: Int64(userProfile.id), token: userProfile.apiToken)
        await accountManager.userProfileStore.addUserProfile(localUserProfile)
    }

    func __getTokenFromDatabase(userId: Int64) async throws -> SharedApiToken? {
        guard let token = tokenStore.tokenFor(userId: TokenStore.UserId(userId)) else {
            return nil
        }

        return SharedApiToken(from: token.apiToken)
    }

    func __persistTokenForAccount(userId: Int64, token: SharedApiToken) async throws {
        tokenStore.removeTokenFor(userId: TokenStore.UserId(userId))

        @InjectService var deviceManager: DeviceManagerable
        let deviceId = try await deviceManager.getOrCreateCurrentDevice().uid

        let apiToken = ApiToken(
            accessToken: token.accessToken,
            expiresIn: Int(token.expiresIn),
            refreshToken: token.refreshToken,
            scope: token.scope ?? "",
            tokenType: token.tokenType,
            userId: Int(userId),
            expirationDate: Date.distantFuture
        )

        tokenStore.addToken(newToken: apiToken, associatedDeviceId: deviceId)
    }
}
