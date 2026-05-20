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

import AuthenticatorCore
import AuthenticatorResources
import CoreAuthenticator
import DesignSystem
import InfomaniakCoreSwiftUI
import SwiftUI

public struct LoginView: View {
    private enum Field: Hashable {
        case password
        case clearPassword
    }

    @State private var password = ""
    @State private var isShowingClearPassword = false
    @FocusState private var focusedField: Field?

    let account: UIMustReLoginAccount

    private var shouldShowError: Bool {
        account.status.hadIncorrectPassword || account.status.lastIssue != nil
    }

    private var errorText: String {
        if account.status.hadIncorrectPassword {
            return AuthenticatorResourcesStrings.wrongPasswordLabel
        } else if let issue = account.status.lastIssue {
            switch issue.cause {
            case is IssueRetriableCauseServerUnavailable:
                return AuthenticatorResourcesStrings.connectionFailedTitle
            case is IssueRetriableCauseNetworkIssue:
                return AuthenticatorResourcesStrings.noInternetTitle
            case let cause as IssueRetriableCauseOther:
                return AuthenticatorResourcesStrings.connectionFailedTitle + "\n(\(cause.errorCode) - \(cause.message))"
            default:
                return AuthenticatorResourcesStrings.connectionFailedTitle
            }
        } else {
            return AuthenticatorResourcesStrings.connectionFailedTitle
        }
    }

    public init(account: UIMustReLoginAccount) {
        self.account = account
    }

    public var body: some View {
        Form {
            Section {
                AccountLabel(account: account.account, size: .small)

                HStack {
                    ZStack {
                        SecureField(AuthenticatorResourcesStrings.passwordLabel, text: $password)
                            .lineLimit(1)
                            .opacity(isShowingClearPassword ? 0 : 1)
                            .font(.Token.callout)
                            .focused($focusedField, equals: .password)

                        TextField(AuthenticatorResourcesStrings.passwordLabel, text: $password)
                            .lineLimit(1)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .opacity(isShowingClearPassword ? 1 : 0)
                            .font(.Token.callout)
                            .focused($focusedField, equals: .clearPassword)
                    }

                    Button(action: onShowPasswordTapped) {
                        Image(systemName: isShowingClearPassword ? "eye.slash" : "eye")
                    }
                }

            } header: {
                VStack(alignment: .center, spacing: IKPadding.medium) {
                    Text(AuthenticatorResourcesStrings.logInTitle)
                        .font(.Token.title2)

                    Text(AuthenticatorResourcesStrings.logInDescription)
                        .font(.Token.callout)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .textCase(nil)
                .listRowInsets(EdgeInsets(top: IKPadding.medium, leading: 0, bottom: IKPadding.huge, trailing: 0))
            } footer: {
                VStack(alignment: .leading) {
                    Link(destination: URLConstants.recoverPassword.url) {
                        Label {
                            Text(AuthenticatorResourcesStrings.passwordForgottenButton)
                        } icon: {
                            AuthenticatorResourcesAsset.Images.circleInformationFill.swiftUIImage
                        }
                    }
                    .padding(.top, value: .large)
                    .accessibilityHint(AuthenticatorResourcesStrings.contentDescriptionButtonExternalLink)

                    Button(AuthenticatorResourcesStrings.continueButton, action: onContinueTapped)
                        .controlSize(.large)
                        .disabled(password.isEmpty)
                        .buttonStyle(.ikBorderedProminent)
                        .ikButtonLoading(account.status.sendCredentials == nil)
                        .ikButtonFullWidth(true)
                        .padding(.vertical, value: .small)
                }
                .listRowInsets(EdgeInsets())
            }
            .headerProminence(.increased)
        }
        .authScrollViewStyle()
        .scrollBounceBehavior(.basedOnSize)
        .alert(AuthenticatorResourcesStrings.connectionFailedTitle, isPresented: .constant(shouldShowError)) {
            if let skip = account.skip {
                Button(AuthenticatorResourcesStrings.passTitle, action: skip)
            }

            Button(AuthenticatorResourcesStrings.retryTitle) {}
                .keyboardShortcut(.defaultAction)
        } message: {
            Text(errorText)
        }
    }

    private func onContinueTapped() {
        guard let sendCredentials = account.status.sendCredentials else { return }
        sendCredentials(CredentialsForMigration(
            confirmedEmail: account.account.email,
            password: password
        ))
    }

    private func onShowPasswordTapped() {
        isShowingClearPassword.toggle()
        if let focusedField {
            self.focusedField = focusedField == .password ? .clearPassword : .password
        }
    }
}
