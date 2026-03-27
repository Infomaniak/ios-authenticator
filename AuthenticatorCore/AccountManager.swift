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
@preconcurrency import CoreAuthenticator
import DeviceAssociation
import Foundation
@preconcurrency import InfomaniakCore
import InfomaniakDI
import InfomaniakLogin
import InfomaniakNotifications
import InterAppLogin
import OSLog

extension CoreAuthenticator.Account: @unchecked @retroactive Sendable {}

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

    func getAccountsIds() async -> [Int]
    func createAndSetCurrentAccount(code: String, codeVerifier: String) async throws
    func createAccounts(derivedAccounts: [ConnectedAccount]) async throws
    func createAccount(token: ApiToken) async throws
    func getApiFetcher(token: ApiToken) async -> ApiFetcher
    func removeAccount(userId: Int64) async
}

public extension AccountManager {
    enum DomainError: Error {
        case tokenKeyExchangeFailed
        case missingAccounts
    }
}

public actor AccountManager: AccountManagerable {
    @LazyInjectService private var tokenStore: TokenStore
    @LazyInjectService private var networkLoginService: InfomaniakNetworkLoginable
    @LazyInjectService private var deviceManager: DeviceManagerable
    @LazyInjectService private var authenticatorFacade: AuthenticatorFacade
    @LazyInjectService private var notificationService: InfomaniakNotifications

    public var accounts: [ApiToken] {
        return tokenStore.getAllTokens().values.map { $0.apiToken }
    }

    public let userProfileStore = UserProfileStore()

    private var apiFetchers: [UserId: ApiFetcher] = [:]
    private let refreshTokenDelegate = AuthenticatorRefreshTokenDelegate()

    public func createAndSetCurrentAccount(code: String, codeVerifier: String) async throws {
        let token = try await networkLoginService.apiTokenUsing(code: code, codeVerifier: codeVerifier)
        try await createAccount(token: token)
    }

    public func createAccounts(derivedAccounts: [ConnectedAccount]) async throws {
        let deviceId = try await deviceManager.getOrCreateCurrentDevice().uid

        var accounts: [CoreAuthenticator.Account] = []
        for derivedAccount in derivedAccounts {
            tokenStore.addToken(newToken: derivedAccount.token, associatedDeviceId: deviceId)
            accounts.append(Account(from: derivedAccount.userProfile))
        }

        try await createAccounts(accounts: accounts)
    }

    public func createAccount(token: ApiToken) async throws {
        let deviceId = try await deviceManager.getOrCreateCurrentDevice().uid

        let temporaryApiFetcher = ApiFetcher(token: token, delegate: refreshTokenDelegate)
        let user = try await userProfileStore.updateUserProfile(with: temporaryApiFetcher)

        tokenStore.addToken(newToken: token, associatedDeviceId: deviceId)

        let account = Account(from: user)

        try await createAccounts(accounts: [account])
    }

    private func createAccounts(accounts: [CoreAuthenticator.Account]) async throws {
        guard !accounts.isEmpty else {
            throw DomainError.missingAccounts
        }

        try await authenticatorFacade.addAccounts(connectedAccounts: accounts)

        var atLeastOneAccountAdded = false
        for account in accounts {
            guard let newToken = tokenStore.tokenFor(userId: TokenStore.UserId(account.id))?.apiToken else {
                continue
            }

            atLeastOneAccountAdded = true

            let apiFetcher = getApiFetcher(token: newToken)
            attachDeviceToApiToken(newToken, apiFetcher: apiFetcher)
            async let _ = notificationService.updateTopicsIfNeeded([Topic.twoFAPushChallenge], userApiFetcher: apiFetcher)
        }

        if !atLeastOneAccountAdded {
            throw DomainError.tokenKeyExchangeFailed
        }
    }

    public func getApiFetcher(token: ApiToken) -> ApiFetcher {
        if let apiFetcher = apiFetchers[token.userId] {
            return apiFetcher
        }

        let newApiFetcher = ApiFetcher(token: token, delegate: refreshTokenDelegate)
        apiFetchers[token.userId] = newApiFetcher
        return newApiFetcher
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

    public func removeAccount(userId: Int64) async {
        guard let token = tokenStore.removeTokenFor(userId: TokenStore.UserId(userId)) else {
            return
        }

        do {
            try await authenticatorFacade.removeAccount(token: token.accessToken, id: userId)
        } catch {
            SentryDebug.capture(error: error)
        }
    }
}
