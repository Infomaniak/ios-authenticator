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
import InfomaniakCore

public extension UserDefaults.Keys {
    static let appLock = UserDefaults.Keys(rawValue: "appLock")
    static let notificationsEnabled = UserDefaults.Keys(rawValue: "notificationsEnabled")
    static let matomoAuthorized = UserDefaults.Keys(rawValue: "matomoAuthorized")
    static let sentryAuthorized = UserDefaults.Keys(rawValue: "sentryAuthorized")
    static let theme = UserDefaults.Keys(rawValue: "theme")
}

public extension UserDefaults {
    var isAppLockEnabled: Bool {
        get {
            if object(forKey: key(.appLock)) == nil {
                set(DefaultPreferences.appLock, forKey: key(.appLock))
            }
            return bool(forKey: key(.appLock))
        }
        set {
            set(newValue, forKey: key(.appLock))
        }
    }

    var isSentryAuthorized: Bool {
        get {
            if object(forKey: key(.sentryAuthorized)) == nil {
                set(DefaultPreferences.sentryAuthorized, forKey: key(.sentryAuthorized))
            }
            return bool(forKey: key(.sentryAuthorized))
        }
        set {
            set(newValue, forKey: key(.sentryAuthorized))
        }
    }

    var isNotificationsEnabled: Bool {
        get {
            if object(forKey: key(.notificationsEnabled)) == nil {
                set(DefaultPreferences.notificationsEnabled, forKey: key(.notificationsEnabled))
            }
            return bool(forKey: key(.notificationsEnabled))
        }
        set {
            set(newValue, forKey: key(.notificationsEnabled))
        }
    }
}
