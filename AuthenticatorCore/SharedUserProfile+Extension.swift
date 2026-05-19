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
import InfomaniakCore

extension UserProfile {
    init(from sharedUserProfile: SharedUserProfile) {
        self.init(
            id: Int(sharedUserProfile.id),
            displayName: sharedUserProfile.displayName ?? "\(sharedUserProfile.firstname) \(sharedUserProfile.lastname)",
            firstName: sharedUserProfile.firstname,
            lastName: sharedUserProfile.lastname,
            email: sharedUserProfile.email
        )
    }
}

extension SharedUserProfile: @retroactive @unchecked Sendable {
    convenience init(from userProfile: UserProfile, sharedApiToken: SharedApiToken) {
        let lastChangedPasswordDate = userProfile.preferences?.security?.dateLastChangedPassword ?? Date.now
        let sharedSecurity = SharedSecurity(
            score: Int32(userProfile.preferences?.security?.score ?? 100),
            dateLastChangedPassword: Int64(lastChangedPasswordDate.timeIntervalSince1970)
        )
        self.init(
            id: Int32(userProfile.id),
            displayName: userProfile.displayName,
            firstname: userProfile.firstName,
            lastname: userProfile.lastName,
            email: userProfile.email,
            avatar: userProfile.avatar,
            login: userProfile.email,
            isStaff: userProfile.isStaff ?? false,
            preferences: Preferences(
                security: sharedSecurity,
                organizationPreference: SharedOrganizationPreference(currentOrganizationId: -1)
            ),
            apiToken: sharedApiToken
        )
    }
}
