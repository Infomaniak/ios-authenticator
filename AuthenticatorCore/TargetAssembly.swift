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

import CoreAuthenticator
import DeviceAssociation
import Foundation
import InAppTwoFactorAuthentication
@preconcurrency import InfomaniakCore
import InfomaniakCoreCommonUI
import InfomaniakDI
import InfomaniakLogin
import InfomaniakNotifications
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
open class TargetAssembly: @unchecked Sendable {
    private static let logger = Logger(category: "TargetAssembly")
    private static let realmRootPath = "authenticator"

    private static let apiEnvironment: InfomaniakCore.ApiEnvironment = .prod
    public static let loginConfig = InfomaniakLogin.Config(
        clientId: "A7B265CD-C9DB-4E6B-8236-2DFF60F146FC",
        loginURL: URL(string: "https://login.\(apiEnvironment.host)/")!,
        accessType: nil
    )

    public init() {
        InfomaniakCore.ApiEnvironment.current = Self.apiEnvironment
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        Self.setupDI()
    }

    open class func getCommonServices() -> [Factory] {
        return [
            Factory(type: AppLaunchCounter.self) { _, _ in
                AppLaunchCounter()
            },
            Factory(type: ConnectedAccountManagerable.self) { _, _ in
                ConnectedAccountManager(currentAppKeychainIdentifier: AppIdentifierBuilder.euriaKeychainIdentifier)
            },
            Factory(type: InfomaniakNotifications.self) { _, _ in
                InfomaniakNotifications(appGroup: Constants.appGroupIdentifier)
            },
            Factory(type: InAppTwoFactorAuthenticationManagerable.self) { _, _ in
                InAppTwoFactorAuthenticationManager()
            },
            Factory(type: AuthenticatorFacade.self) { _, resolver in
                let appGroupPath = try resolver.resolve(
                    type: AppGroupPathProvidable.self,
                    forCustomTypeIdentifier: nil,
                    factoryParameters: nil,
                    resolver: resolver
                )

                let sentryWrapper = SentryKMPWrapper()

                let tokenBridge = TokenBridgeImplementation()

                return AuthenticatorFacade.companion.create(
                    apiHost: apiEnvironment.host,
                    userAgent: UserAgentBuilder().userAgent,
                    clientId: Self.loginConfig.clientId,
                    databaseNameOrPath: appGroupPath.realmRootURL.appending(path: "accounts.db").path(),
                    crashReport: sentryWrapper,
                    tokenBridge: tokenBridge
                )
            },
            Factory(type: DeviceManagerable.self) { _, _ in
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
                return DeviceManager(appGroupIdentifier: Constants.sharedAppGroupName,
                                     appMarketingVersion: version,
                                     capabilities: [.twoFactorAuthenticationChallengeApproval])
            },
            Factory(type: AccountManagerable.self) { _, _ in
                AccountManager()
            },
            Factory(type: KeychainHelper.self) { _, _ in
                KeychainHelper(accessGroup: AppIdentifierBuilder.authenticatorKeychainIdentifier)
            },
            Factory(type: TokenStore.self) { _, _ in
                TokenStore()
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
