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

import AuthenticatorResources
import CoreAuthenticator
import SwiftUI

public struct UIAccount: Identifiable, Hashable, Sendable {
    public let id: Int64
    public let name: String
    public let email: String
    public let profilePictureURL: URL?
    public let status: Status

    public var isDisabled: Bool {
        status == .loggedOut
    }

    public init(id: Int64, name: String, email: String, profilePictureURL: URL?, status: Status) {
        self.id = id
        self.name = name
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.status = status
    }

    public enum Status: Sendable {
        case protected
        case partiallyProtected
        case loggedOut
        case loginFailed
        case loginFailedRetriable

        public var color: Color.Token.StatusColors {
            switch self {
            case .protected:
                .valid
            case .partiallyProtected:
                .warning
            case .loggedOut, .loginFailed, .loginFailedRetriable:
                .disabled
            }
        }

        public var icon: Image {
            switch self {
            case .protected:
                AuthenticatorResourcesAsset.Images.shieldCheck.swiftUIImage
            case .partiallyProtected:
                AuthenticatorResourcesAsset.Images.shieldExclamationmark.swiftUIImage
            case .loggedOut, .loginFailed, .loginFailedRetriable:
                AuthenticatorResourcesAsset.Images.circleSlash.swiftUIImage
            }
        }

        public var title: String {
            switch self {
            case .protected:
                AuthenticatorResourcesStrings.accountProtected
            case .partiallyProtected:
                AuthenticatorResourcesStrings.accountPartiallyProtectedTitle
            case .loggedOut, .loginFailed, .loginFailedRetriable:
                AuthenticatorResourcesStrings.accountLoggedOut
            }
        }

        public var description: String? {
            switch self {
            case .partiallyProtected:
                AuthenticatorResourcesStrings.accountPartiallyProtectedDescription
            default:
                nil
            }
        }
    }
}

public extension UIAccount {
    init(account: CoreAuthenticator.Account) {
        let avatarURL: URL?
        if let avatarURLString = account.avatarUrl,
           let url = URL(string: avatarURLString) {
            avatarURL = url
        } else {
            avatarURL = nil
        }
        self.init(
            id: account.id,
            name: account.fullName,
            email: account.email,
            profilePictureURL: avatarURL,
            status: UIAccount.Status(accountStatus: account.status)
        )
    }
}

extension UIAccount.Status {
    init(accountStatus: AccountStatus) {
        switch accountStatus {
        case let loggedIn as AccountStatusLoggedIn:
            if loggedIn.isSecured {
                self = .protected
            } else {
                self = .partiallyProtected
            }
        case is AccountStatusNotConnectedReLogin:
            self = .loggedOut
        case let loginFailed as AccountStatusNotConnectedLoginFailed:
            if loginFailed.issue is IssueRetriable {
                self = .loginFailedRetriable
            } else {
                self = .loginFailed
            }
        default:
            self = .loggedOut
        }
    }
}
