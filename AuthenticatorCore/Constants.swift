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

import Foundation
@preconcurrency import InfomaniakCore

public enum Constants {
    public static let bundleId = "com.infomaniak.auth"
    public static let sharedAppGroupName = "group.com.infomaniak"
    public static let appName = "Infomaniak Authenticator"
    public static let appGroupIdentifier = "group.\(Constants.bundleId)"

    public static let matomoId = "40"

    public static func autologinURL(to destination: URL) -> URL? {
        return URL(string: "https://\(Constants.managerHost)/v3/mobile_login/?url=\(destination.absoluteString)")
    }

    public static let managerHost = "manager.\(ApiEnvironment.current.host)"
}

public struct URLConstants: Sendable {
    public static let githubRepository = URLConstants(urlString: "https://github.com/Infomaniak/ios-authenticator")
    public static let matomo = URLConstants(urlString: "https://analytics.infomaniak.com/matomo.php")

    public static let accountActivity =
        URLConstants(urlString: "https://\(Constants.managerHost)/v3/ng/profile/user/connection-history/activity")
    public static let accountParameters =
        URLConstants(
            urlString: "https://\(Constants.managerHost)/v3/ng/profile/user/security-and-recovery-parameters/dashboard?global-settings=user-account-security"
        )
    public static let support = URLConstants(urlString: "https://infomaniak.com/gtl/help")
    public static let recoverPassword = URLConstants(urlString: "https://login.infomaniak.com/fr/recover/password")

    private var urlString: String

    public var url: URL {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        return url
    }
}
