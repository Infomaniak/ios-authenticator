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

import Alamofire
import CoreAuthenticator
import InfomaniakCore
import InfomaniakDI
import InfomaniakLogin
import OSLog

final class KeyBasedRefreshAuthenticator: OAuthAuthenticator {
    enum DomainError: Error {
        case tokenNotFoundAfterRefresh(userId: Int)
    }

    override func refresh(
        _ credential: OAuthAuthenticator.Credential,
        for session: Session,
        completion: @escaping @Sendable (Result<OAuthAuthenticator.Credential, Error>) -> Void
    ) {
        // It is necessary that the app stays awake while we refresh the token
        let expiringActivity = ExpiringActivity()
        expiringActivity.start()
        Task {
            defer { expiringActivity.endAll() }
            do {
                let token = try await refreshToken(for: credential.userId)
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func refreshToken(for userId: Int, retryLeft: Int = 3) async throws -> ApiToken {
        @InjectService var authenticatorFacade: AuthenticatorFacade
        @InjectService var tokenStore: TokenStore

        do {
            try await authenticatorFacade.refreshTokenFor(userId: Int64(userId))
            guard let token = tokenStore.tokenFor(userId: userId) else {
                throw DomainError.tokenNotFoundAfterRefresh(userId: userId)
            }

            return token.apiToken
        } catch {
            Logger.general.error("Failed to refresh token retry left \(retryLeft): \(error)")
            guard retryLeft > 0 else {
                SentryDebug.capture(error: error)
                throw error
            }

            try await Task.sleep(for: .seconds(1))
            return try await refreshToken(for: userId, retryLeft: retryLeft - 1)
        }
    }
}
