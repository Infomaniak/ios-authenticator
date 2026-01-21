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
import SwiftUI

// swiftlint:disable nesting
public extension Color {
    enum Token {
        typealias AuthColor = AuthenticatorResourcesAsset.Colors
        /// Main color used by the Authenticator app.
        public static let primary = Color(light: AuthColor.authenticator, dark: AuthColor.authenticator)

        // MARK: - Semantic tokens

        public enum Text {
            public static let primary = Color(light: AuthColor.neutralBlue800, dark: AuthColor.neutralBlue50)
            public static let secondary = Color(light: AuthColor.neutralBlue500, dark: AuthColor.neutralBlue200)
            public static let tertiary = Color(light: AuthColor.neutralBlue400, dark: AuthColor.neutralBlue500)
            public static let coloredBackground = Color(light: AuthColor.neutralBlue100, dark: AuthColor.neutralBlue800)
        }

        /// General background colors
        public enum Surface {
            public static let primary = Color(light: AuthColor.neutralBlue100, dark: AuthColor.neutralBlue800)
            public static let secondary = Color(light: AuthColor.neutralBlue200, dark: AuthColor.neutralBlue700)
        }

        /// Green, Orange, Red status colors
        public enum Status {
            /// Green
            public static let valid = Color(light: AuthColor.green500, dark: AuthColor.green300)
            /// Orange
            public static let warning = Color(light: AuthColor.orange500, dark: AuthColor.orange300)
            /// Red
            public static let error = Color(light: AuthColor.red500, dark: AuthColor.red300)
        }
    }
}

// swiftlint:enable nesting

extension Color {
    init(light: AuthenticatorResourcesColors, dark: AuthenticatorResourcesColors) {
        self.init(uiColor: UIColor(light: light, dark: dark))
    }
}

extension UIColor {
    convenience init(light: AuthenticatorResourcesColors, dark: AuthenticatorResourcesColors) {
        self.init { $0.userInterfaceStyle == .dark ? dark.color : light.color }
    }
}
