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
import AuthenticatorMainView
import AuthenticatorOnboardingView
import AuthenticatorPreloadingView
import SwiftUI

public struct RootView: View {
    @EnvironmentObject private var rootViewState: RootViewState

    public init() {}

    public var body: some View {
        ZStack {
            switch rootViewState.state {
            case .mainView(let mainViewState):
                MainView()
                    .environmentObject(mainViewState)
            case .preloading:
                PreloadingView()
            case .newAccount(let step):
                OnboardingView(steps: OnboardingStep.loginSteps, currentStep: step)
            case .migration(let step):
                OnboardingView(steps: OnboardingStep.migrationSteps, currentStep: step)
            case .updateRequired:
                Text("Updated required") // TODO: Implement update required screen
            }
        }
    }
}

#Preview {
    RootView()
}
