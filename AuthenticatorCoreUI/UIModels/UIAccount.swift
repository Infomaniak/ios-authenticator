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
import SwiftUI

public struct UIAccount: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let profilePictureURL: URL?
    public let status: Status

    public init(id: String, name: String, email: String, profilePictureURL: URL?, status: Status) {
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

        public var color: Color {
            switch self {
            case .protected:
                .Token.Status.valid
            case .partiallyProtected:
                .Token.Status.warning
            case .loggedOut:
                .Token.Status.error
            }
        }

        public var icon: Image {
            switch self {
            case .protected:
                AuthenticatorResourcesAsset.Images.shieldCheck.swiftUIImage
            case .partiallyProtected:
                AuthenticatorResourcesAsset.Images.shieldWarning.swiftUIImage
            case .loggedOut:
                AuthenticatorResourcesAsset.Images.circleCross.swiftUIImage
            }
        }

        public var title: String {
            switch self {
            case .protected:
                AuthenticatorResourcesStrings.accountProtected
            case .partiallyProtected:
                AuthenticatorResourcesStrings.accountPartiallyProtectedTitle
            case .loggedOut:
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
