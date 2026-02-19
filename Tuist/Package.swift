// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Alamofire": .framework,
        "DesignSystem": .framework,
        "InfomaniakCoreCommonUI": .framework,
        "InfomaniakCoreSwiftUI": .framework,
        "InfomaniakCoreUIResources": .framework,
        "InfomaniakCore": .framework,
        "InfomaniakDI": .framework,
        "InfomaniakLogin": .framework,
        "InfomaniakCreateAccount": .framework,
        "InfomaniakNotifications": .framework,
        "InterAppLogin": .framework,
        "SwiftModalPresentation": .framework,
        "Lottie": .framework,
        "VersionChecker": .framework,
        "_LottieStub": .framework,
        "Nuke": .framework,
        "NukeUI": .framework
    ]
)
#endif

let package = Package(
    name: "Authenticator",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.5.1")),
        .package(url: "https://github.com/getsentry/sentry-cocoa", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/Infomaniak/ios-core", .upToNextMajor(from: "18.4.1")),
        .package(url: "https://github.com/Infomaniak/ios-core-ui", .upToNextMajor(from: "24.3.0")),
        .package(url: "https://github.com/Infomaniak/ios-create-account", .upToNextMajor(from: "23.2.0")),
        .package(url: "https://github.com/Infomaniak/ios-login", .upToNextMajor(from: "7.5.0")),
        .package(url: "https://github.com/Infomaniak/ios-onboarding", .upToNextMajor(from: "1.4.4")),
        .package(url: "https://github.com/Infomaniak/ios-version-checker", .upToNextMajor(from: "16.0.0")),
        .package(url: "https://github.com/Infomaniak/ios-features", .upToNextMajor(from: "8.4.3")),
        .package(url: "https://github.com/Infomaniak/ios-notifications", .upToNextMajor(from: "15.1.0")),
        .package(url: "https://github.com/Infomaniak/swift-modal-presentation", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/matomo-org/matomo-sdk-ios", .upToNextMajor(from: "7.7.0"))
    ]
)
