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
import DesignSystem
@preconcurrency import InfomaniakCoreCommonUI
import InfomaniakCoreSwiftUI
import InfomaniakDI
import SwiftUI

public struct LockedAppView: View {
    @LazyInjectService private var appLockHelper: AppLockHelper

    @EnvironmentObject private var navigationState: RootViewState

    private static let onboardingLogoHeight: CGFloat = 56

    @State private var isEvaluatingPolicy = false

    public init() {}

    public var body: some View {
        ZStack {
            VStack(spacing: IKPadding.large) {
                AuthenticatorResourcesAsset.Images.lock.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 187, height: 187)

                Text(AuthenticatorResourcesStrings.lockAppTitle)
                    .font(.Token.title2)
                    .foregroundStyle(Color.Token.Text.primary)
            }

            VStack {
                VStack {
                    AuthenticatorResourcesAsset.Images.onboardingLogo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: LockedAppView.onboardingLogoHeight)
                        .accessibilityHidden(true)
                }
                .frame(maxHeight: .infinity, alignment: .leading)

                Button(AuthenticatorResourcesStrings.buttonUnlock, action: unlockApp)
                    .buttonStyle(.ikBorderedProminent)
                    .controlSize(.large)
                    .ikButtonFullWidth(true)
                    .ikButtonLoading(isEvaluatingPolicy)
            }
            .padding(.top, IKPadding.large)
            .padding(.bottom, value: .giant)
        }
        .padding(.horizontal, value: .large)
        .onAppear {
            unlockApp()
        }
        .matomoView(view: ["LockedAppView"])
    }

    private func unlockApp() {
        guard !isEvaluatingPolicy else { return }

        Task { @MainActor in
            isEvaluatingPolicy = true
            if await (try? appLockHelper.evaluatePolicy(reason: AuthenticatorResourcesStrings.lockAppTitle)) == true {
                appLockHelper.setTime()
                await navigationState.transitionToMainViewIfPossible()
            } else {
                isEvaluatingPolicy = false
            }
        }
    }
}

#Preview {
    LockedAppView()
}
