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
import InfomaniakOnboarding

extension Slide {
    static let onboardingSlides: [Slide] = [
        Slide(
            backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
            backgroundImageTintColor: nil,
            content: .illustration(AuthenticatorResourcesAsset.Images.onboardingShield.image),
            bottomView: OnboardingTextBottomView(\.onBoardingLoginTitle, descriptionKey: \.onBoardingLoginDescription)
        ),
        Slide(
            backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
            backgroundImageTintColor: nil,
            content: .illustration(AuthenticatorResourcesAsset.Images.onboardingCreation.image),
            bottomView: OnboardingProgressBarBottomView(\.onBoardingSecuringAccount)
        ),
        onboardingSuccessSlide,
        onboardingFaceIdSlide
    ]

    static let migratingSlides: [Slide] = [
        Slide(
            backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
            backgroundImageTintColor: nil,
            content: .illustration(AuthenticatorResourcesAsset.Images.onboardingGrid.image),
            bottomView: OnboardingTextBottomView(\.onBoardingMigrationTitle, descriptionKey: \.onBoardingMigrationDescription)
        ),
        Slide(
            backgroundImage: AuthenticatorResourcesAsset.Images.onboardingBlur.image,
            backgroundImageTintColor: nil,
            content: .illustration(AuthenticatorResourcesAsset.Images.onboardingMigration.image),
            bottomView: OnboardingProgressBarBottomView(\.onBoardingSecuringAccount)
        ),
        onboardingSuccessSlide,
        onboardingFaceIdSlide
    ]

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
}
