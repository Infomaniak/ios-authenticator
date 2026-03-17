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
@preconcurrency import InfomaniakCore
import InfomaniakDI
import InfomaniakLogin
import InfomaniakNotifications
import OSLog

public extension ApiFetcher {
    convenience init(token: ApiToken, delegate: RefreshTokenDelegate) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        self.init(decoder: decoder)
        createAuthenticatedSession(
            token,
            authenticator: OAuthAuthenticator(refreshTokenDelegate: delegate),
            additionalAdapters: [UserAgentAdapter()]
        )
    }
}

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
    @InjectService private var tokenStore: TokenStore
    @InjectService private var networkLoginService: InfomaniakNetworkLoginable
    @LazyInjectService private var deviceManager: DeviceManagerable

    public var accounts: [ApiToken] {
        return tokenStore.getAllTokens().values.map { $0.apiToken }
    }

    public var userProfileStore: InfomaniakCore.UserProfileStore
    public var currentSession: Int?

    private let refreshTokenDelegate = AuthenticatorRefreshTokenDelegate()

    init(userProfileStore: InfomaniakCore.UserProfileStore, currentSession: Int?) {
        self.userProfileStore = userProfileStore
        self.currentSession = currentSession
    }

    init() {
        self.init(userProfileStore: UserProfileStore(), currentSession: nil)
    }

    public func createAndSetCurrentAccount(code: String, codeVerifier: String) async throws {
        let token = try await networkLoginService.apiTokenUsing(code: code, codeVerifier: codeVerifier)

        do {
            try await createAccount(token: token)
        } catch {
            throw error
        }
    }

    public func createAccount(token: ApiToken) async throws {
        let temporaryApiFetcher = ApiFetcher(token: token, delegate: refreshTokenDelegate)
        let user = try await userProfileStore.updateUserProfile(with: temporaryApiFetcher)

        let deviceId = try await deviceManager.getOrCreateCurrentDevice().uid
        tokenStore.addToken(newToken: token, associatedDeviceId: deviceId)
        attachDeviceToApiToken(token, apiFetcher: temporaryApiFetcher)
    }

    private func attachDeviceToApiToken(_ token: ApiToken, apiFetcher: ApiFetcher) {
        Task {
            do {
                let device = try await deviceManager.getOrCreateCurrentDevice()
                try await deviceManager.attachDeviceIfNeeded(device, to: token, apiFetcher: apiFetcher)
            } catch {
                Logger.general.error("Failed to attach device to token: \(error.localizedDescription)")
            }
        }
    }

    public func getAccountsIds() async -> [Int] {
        return accounts.map { $0.userId }
    }
}
