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
import ProjectDescription
import ProjectDescriptionHelpers

let preloadingView = Feature(name: "PreloadingView")
let accountsView = Feature(name: "AccountsView")

let settingsView = Feature(
    name: "SettingsView",
    additionalDependencies: [
        TargetDependency.external(name: "InfomaniakPrivacyManagement"),
        TargetDependency.external(name: "InfomaniakCoreUIResources")
    ]
)

let mainView = Feature(
    name: "MainView",
    additionalDependencies: [
        settingsView,
        accountsView,
        TargetDependency.external(name: "InfomaniakCoreUIResources"),
        TargetDependency.external(name: "VersionChecker")
    ]
)

let onboardingView = Feature(name: "OnboardingView", additionalDependencies: [
    TargetDependency.external(name: "InfomaniakCoreUIResources"),
    TargetDependency.external(name: "InfomaniakOnboarding"),
    TargetDependency.external(name: "Lottie")
])

let rootView = Feature(
    name: "RootView",
    dependencies: [mainView, preloadingView, onboardingView, TargetDependency.external(name: "VersionChecker")]
)

let mainiOSAppFeatures = [
    rootView,
    mainView,
    settingsView,
    preloadingView,
    onboardingView,
    accountsView
]

let project = Project(
    name: Constants.projectName,
    targets: mainiOSAppFeatures.asTargets + [
        .target(
            name: Constants.projectName,
            destinations: .iOS,
            product: .app,
            bundleId: Constants.baseIdentifier,
            deploymentTargets: Constants.deploymentTarget,
            infoPlist: "\(Constants.projectName)/Resources/Info.plist",
            sources: "\(Constants.projectName)/Sources/**",
            resources: [
                "\(Constants.projectName)/Resources/LaunchScreen.storyboard",
                "\(Constants.projectName)/Resources/Assets.xcassets", // Needed for AppIcon and LaunchScreen
                "\(Constants.projectName)/Resources/PrivacyInfo.xcprivacy",
                "\(Constants.projectName)/Resources/Localizable/**/InfoPlist.strings"
            ],
            entitlements: "\(Constants.projectName)/Resources/\(Constants.projectName).entitlements",
            scripts: [
                Constants.swiftlintScript,
                Constants.stripSymbolsScript
            ],
            dependencies: [
                .target(name: "\(Constants.projectName)Core"),
                .target(name: "\(Constants.projectName)CoreUI"),
                rootView.asDependency
            ],
            settings: .settings(base: Constants.baseSettings),
            environmentVariables: [
                "hostname": .environmentVariable(value: "\(ProcessInfo.processInfo.hostName).", isEnabled: true)
            ]
        ),
        .target(name: "\(Constants.projectName)Core",
                destinations: Constants.destinations,
                product: Constants.productTypeBasedOnEnv,
                bundleId: "\(Constants.baseIdentifier).core",
                deploymentTargets: Constants.deploymentTarget,
                infoPlist: .default,
                sources: "\(Constants.projectName)Core/**",
                dependencies: [
                    .target(name: "\(Constants.projectName)Resources"),
                    .external(name: "DesignSystem"),
                    .external(name: "InfomaniakCoreCommonUI"),
                    .external(name: "InfomaniakCoreSwiftUI"),
                    .external(name: "InfomaniakCoreUIKit"),
                    .external(name: "InfomaniakLogin"),
                    .external(name: "Sentry-Dynamic")
                ],
                settings: .settings(base: Constants.baseSettings)),
        .target(name: "\(Constants.projectName)CoreUI",
                destinations: Constants.destinations,
                product: Constants.productTypeBasedOnEnv,
                bundleId: "\(Constants.baseIdentifier).coreui",
                deploymentTargets: Constants.deploymentTarget,
                infoPlist: .default,
                sources: "\(Constants.projectName)CoreUI/**",
                dependencies: [
                    .target(name: "\(Constants.projectName)Core"),
                    .external(name: "InfomaniakCoreUIResources")
                ],
                settings: .settings(base: Constants.baseSettings)),
        .target(name: "\(Constants.projectName)Resources",
                destinations: Constants.destinations,
                product: Constants.productTypeBasedOnEnv,
                bundleId: "\(Constants.baseIdentifier).resources",
                deploymentTargets: Constants.deploymentTarget,
                infoPlist: .default,
                resources: [
                    "\(Constants.projectName)Resources/**/*.xcassets",
                    "\(Constants.projectName)Resources/**/*.strings",
                    "\(Constants.projectName)Resources/**/*.stringsdict",
                    "\(Constants.projectName)Resources/**/*.json"
                ],
                settings: .settings(base: Constants.baseSettings))
    ]
)
