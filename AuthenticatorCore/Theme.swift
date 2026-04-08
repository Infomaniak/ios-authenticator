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

public enum Theme {
    case light
    case dark
    case system
    public var localizedName: String {
        switch self {
        case .dark:
            return "Sombre"
        case .light:
            return "Clair"
        case .system:
            return "Système"
        }
    }

    public var rawValue: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        case .system:
            return "system"
        }
    }
}
