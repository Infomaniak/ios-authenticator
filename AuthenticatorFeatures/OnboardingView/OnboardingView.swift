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

import AuthenticationServices
import AuthenticatorCore
import AuthenticatorCoreUI
import AuthenticatorResources
import DesignSystem
import InfomaniakCoreCommonUI
import InfomaniakCoreUIResources
import InfomaniakCreateAccount
import InfomaniakDI
import InfomaniakLogin
import InfomaniakOnboarding
import InterAppLogin
import SwiftModalPresentation
import SwiftUI

public struct OnboardingView: View {
    @InjectService private var accountManager: AccountManagerable

    @State private var loginHandler = LoginHandler()
    @State private var excludedUserIds: [Int] = []

    @ModalState(context: ContextKeys.onboarding) private var isPresentingCreateAccount = false

    let type: OnboardingType

    var slides: [Slide] {
        type == .newUser ? Slide.onboardingSlides : Slide.migratingSlides
    }

    public var body: some View {
        CarouselView(slides: slides, selectedSlide: .constant(0)) { _ in
            ContinueWithAccountView(isLoading: loginHandler.isLoading, excludingUserIds: excludedUserIds) {
                login()
            } onLoginWithAccountsPressed: { accounts in
                login(with: accounts)
            } onCreateAccountPressed: {
                isPresentingCreateAccount = true
            }
            .ikButtonFullWidth(true)
            .controlSize(.large)
            .padding(.horizontal, value: .large)
        }
        .appBackground()
        .ignoresSafeArea()
        .sheet(isPresented: $isPresentingCreateAccount) {
            RegisterView(registrationProcess: .mail) { viewController in // TODO: Change with his own registration process
                guard let viewController else { return }
                loginHandler.loginAfterAccountCreation(from: viewController)
            }
        }
        .task {
            loginHandler.isLoading = true
            excludedUserIds = await accountManager.getAccountsIds()
            loginHandler.isLoading = false
        }
    }

    private func login(with accounts: [ConnectedAccount] = []) {
        Task {
            if accounts.isEmpty {
                await loginHandler.login()
            } else {
                await loginHandler.login(with: accounts)
            }
        }
    }

    public enum OnboardingType {
        case newUser
        case migrating
    }
}

#Preview {
    OnboardingView(type: .newUser)
}
