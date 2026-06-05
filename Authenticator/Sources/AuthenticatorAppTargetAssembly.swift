//
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

import AppLock
import AuthenticatorCore
import AuthenticatorResources
import Foundation
import InfomaniakCoreSwiftUI
import InfomaniakDI

class AuthenticatorAppTargetAssembly: TargetAssembly, @unchecked Sendable {
    override class func getCommonServices() -> [Factory] {
        return super.getCommonServices() + [
            Factory(type: AppLockHelper.self) { _, _ in
                AppLockHelper(
                    appLockUIConfiguration: AppLockUIConfiguration(
                        logoImage: AuthenticatorResourcesAsset.Images.onboardingLogo.swiftUIImage,
                        lockImage: AuthenticatorResourcesAsset.Images.lock.swiftUIImage,
                        ikButtonTheme: .mainTheme
                    ),
                    userDefaults: UserDefaults.shared
                )
            }
        ]
    }
}
