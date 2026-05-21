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
import Foundation

public struct UIAccountAlert: Identifiable {
    public enum AlertType {
        case passwordChanged
        case disconnected

        public var title: String {
            switch self {
            case .passwordChanged:
                AuthenticatorResourcesStrings.alertDialogPasswordChangedTitle
            case .disconnected:
                AuthenticatorResourcesStrings.accountDisconnectedTitle
            }
        }

        public func description(email: String) -> String {
            switch self {
            case .passwordChanged:
                AuthenticatorResourcesStrings.alertDialogPasswordChangedText(email)
            case .disconnected:
                AuthenticatorResourcesStrings.accountDisconnectedDescription(email)
            }
        }
    }

    public let id: Int
    public let email: String
    public let type: AlertType
    public let ack: () -> Void
}
