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

import AuthenticatorCoreUI
import AuthenticatorResources
import InfomaniakOnboarding

extension OnboardingStep {
    var slide: Slide {
        switch self {
        case .login, .addAccount:
            return .login
        case .migration:
            return .migration
        case .loginInProgress:
            return .loginInProgress
        case .migrationInProgress:
            return .migrationInProgress
        case .success:
            return .onboardingSuccessSlide
        case .biometry:
            return .onboardingFaceIdSlide
        }
    }
}

extension Slide {
    static let login = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingShield.image),
        bottomView: OnboardingTextBottomView(\.onBoardingLoginTitle, descriptionKey: \.onBoardingLoginDescription)
    )

    static let loginInProgress = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingCreation.image),
        bottomView: OnboardingProgressBarBottomView(\.onBoardingSecuringAccount)
    )

    static let migration = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingGrid.image),
        bottomView: OnboardingTextBottomView(\.onBoardingMigrationTitle, descriptionKey: \.onBoardingMigrationDescription)
    )

    static let migrationInProgress = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingMigration.image),
        bottomView: OnboardingProgressBarBottomView(\.onBoardingSecuringAccount)
    )

    static let onboardingSuccessSlide = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingLogo.image),
        bottomView: OnboardingTextBottomView(\.onBoardingSuccessTitle, descriptionKey: \.onBoardingSuccessDescription)
    )

    static let onboardingFaceIdSlide = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.faceId.image),
        bottomView: OnboardingTextBottomView(\.onBoardingFaceIdTitle, descriptionKey: \.onBoardingFaceIdDescription)
    )

    static let onboardingNotificationsSlide = Slide(
        backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
        backgroundImageTintColor: nil,
        content: .illustration(AuthenticatorResourcesAsset.Images.onboardingNotifications.image),
        bottomView: OnboardingTextBottomView(\.onboardingNotificationsTitle, descriptionKey: \.onboardingNotificationsDescription)
    )
}
