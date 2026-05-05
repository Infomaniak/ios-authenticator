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
import Foundation
import InfomaniakLogin

extension SharedApiToken {
    convenience init(from apiToken: ApiToken) {
        self.init(
            accessToken: apiToken.accessToken,
            refreshToken: apiToken.refreshToken,
            tokenType: apiToken.tokenType,
            expiresIn: Int32(apiToken.expiresIn ?? 7200),
            userId: Int32(apiToken.userId),
            scope: apiToken.scope,
            expiresAt: apiToken.expirationDate.map { KotlinLong(value: Int64($0.timeIntervalSince1970)) }
        )
    }
}
