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

public enum Theme: String, Sendable, CaseIterable, Identifiable {
    case light
    case dark
    case system

    public var id: String {
        return rawValue
    }

    public var asColorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }

    public var localizedName: String {
        switch self {
        case .dark:
            return AuthenticatorResourcesStrings.themeDark
        case .light:
            return AuthenticatorResourcesStrings.themeLight
        case .system:
            return AuthenticatorResourcesStrings.themeSystem
        }
    }

    public var image: Image {
        switch self {
        case .light:
            return AuthenticatorResourcesAsset.Images.circleLight.swiftUIImage
        case .dark:
            return AuthenticatorResourcesAsset.Images.circleDark.swiftUIImage
        case .system:
            return AuthenticatorResourcesAsset.Images.circleLightDark.swiftUIImage
        }
    }
}
