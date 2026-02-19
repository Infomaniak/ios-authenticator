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
import AuthenticatorResources
import InfomaniakCoreUIResources
import InfomaniakDI
import InfomaniakLogin
import InterAppLogin
import SwiftUI

@MainActor
final class LoginHandler: InfomaniakLoginDelegate, ObservableObject {
    @LazyInjectService private var loginService: InfomaniakLoginable

    @Published var isLoading = false
    @Published var error: ErrorDomain?

    enum ErrorDomain: Error, LocalizedError, Equatable {
        case loginFailed(error: Error)
        case genericError

        var errorDescription: String? {
            switch self {
            case .loginFailed(let error):
                return error.localizedDescription
            case .genericError:
                return CoreUILocalizable.anErrorHasOccurred
            }
        }

        static func == (lhs: LoginHandler.ErrorDomain, rhs: LoginHandler.ErrorDomain) -> Bool {
            switch (lhs, rhs) {
            case (.loginFailed, .loginFailed):
                return true
            case (.genericError, .genericError):
                return true
            default:
                return false
            }
        }
    }

    nonisolated func didCompleteLoginWith(code: String, verifier: String) {
        // TODO:
    }

    nonisolated func didFailLoginWith(error: any Error) {
        // TODO:
    }

    func login() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await loginService.asWebAuthenticationLoginFrom(
                anchor: ASPresentationAnchor(),
                useEphemeralSession: true,
                hideCreateAccountButton: true
            )
            try await loginSuccessful(code: result.code, codeVerifier: result.verifier)
        } catch {
            loginFailed(error: error)
        }
    }

    func login(with accounts: [ConnectedAccount]) async {
        // TODO:
    }

    func loginAfterAccountCreation(from viewController: UIViewController) {
        isLoading = true
        defer { isLoading = false }

        loginService.setupWebviewNavbar(
            title: AuthenticatorResourcesStrings.logInButton,
            titleColor: nil,
            color: nil,
            buttonColor: nil,
            clearCookie: false,
            timeOutMessage: nil
        )
        loginService.webviewLoginFrom(viewController: viewController, hideCreateAccountButton: true, delegate: self)
    }

    private func loginSuccessful(code: String, codeVerifier verifier: String) async throws {
        // TODO:
    }

    private func loginFailed(error: Error) {
        guard (error as? ASWebAuthenticationSessionError)?.code != .canceledLogin else { return }

        self.error = .loginFailed(error: error)
        SentryDebug.loginError(error: error, step: "loginFailed")
    }
}
