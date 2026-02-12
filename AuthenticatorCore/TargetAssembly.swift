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
import InfomaniakCoreCommonUI
import InfomaniakDI
import InfomaniakLogin
import InterAppLogin
import OSLog

private let appGroupIdentifier = "group.\(Constants.bundleId)"

public extension UserDefaults {
    nonisolated(unsafe) static let shared = UserDefaults(suiteName: appGroupIdentifier)!
}

extension [Factory] {
    func registerFactoriesInDI() {
        forEach { SimpleResolver.sharedResolver.store(factory: $0) }
    }
}

/// Each target should subclass `TargetAssembly` and override `getTargetServices` to provide additional, target related, services.
@MainActor
open class TargetAssembly {
    private static let logger = Logger(category: "TargetAssembly")
    private static let realmRootPath = "chats"

    private static let apiEnvironment: ApiEnvironment = .prod
    public static let loginConfig = InfomaniakLogin.Config(
        clientId: "", // TODO: Ask to generate one
        loginURL: URL(string: "https://login.\(apiEnvironment.host)/")!,
        accessType: nil
    )

    public init() {
        Self.setupDI()
    }

    open class func getCommonServices() -> [Factory] {
        return [
            Factory(type: ConnectedAccountManagerable.self) { _, _ in
                ConnectedAccountManager(currentAppKeychainIdentifier: AppIdentifierBuilder.euriaKeychainIdentifier)
            },
            Factory(type: AccountManagerable.self) { _, _ in
                AccountManager()
            },
            Factory(type: AppGroupPathProvidable.self) { _, _ in
                guard let provider = AppGroupPathProvider(
                    realmRootPath: realmRootPath,
                    appGroupIdentifier: Constants.appGroupIdentifier
                ) else {
                    fatalError("could not safely init AppGroupPathProvider")
                }

                return provider
            },
            Factory(type: InfomaniakNetworkLoginable.self) { _, _ in
                InfomaniakNetworkLogin(config: loginConfig)
            },
            Factory(type: InfomaniakLoginable.self) { _, _ in
                InfomaniakLogin(config: loginConfig)
            },
            Factory(type: MatomoUtils.self) { _, _ in
                let matomo = MatomoUtils(siteId: Constants.matomoId, baseURL: URLConstants.matomo.url)
                #if DEBUG
                matomo.optOut(true)
                #endif
                return matomo
            },
            Factory(type: AppLockHelper.self) { _, _ in
                AppLockHelper()
            }
        ]
    }

    open class func getTargetServices() -> [Factory] {
        logger.warning("targetServices is not implemented in subclass ? Did you forget to override ?")
        return []
    }

    public static func setupDI() {
        (getCommonServices() + getTargetServices()).registerFactoriesInDI()
    }
}
