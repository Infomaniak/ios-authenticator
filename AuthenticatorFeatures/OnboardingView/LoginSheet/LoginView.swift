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
import AuthenticatorCoreUI
import AuthenticatorResources
import DesignSystem
import SwiftUI

public struct LoginView: View {
    @State private var password = ""

    let account: UIAccount

    public init(account: UIAccount) {
        self.account = account
    }

    public var body: some View {
        Form {
            Section {
                AccountLabel(account: account, size: .small)

                LabeledContent(AuthenticatorResourcesStrings.passwordLabel) {
                    SecureField(AuthenticatorResourcesStrings.requiredLabel, text: $password)
                        .bold(false)
                }
                .bold()
            } header: {
                VStack(alignment: .center, spacing: IKPadding.medium) {
                    Text(AuthenticatorResourcesStrings.logInTitle)
                        .font(.Token.title2)

                    Text(AuthenticatorResourcesStrings.logInDescription)
                        .font(.Token.callout)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, value: .huge)
            } footer: {
                VStack(alignment: .leading) {
                    Link(destination: URLConstants.recoverPassword.url) { // TODO: use real URL
                        Label {
                            Text(AuthenticatorResourcesStrings.passwordForgottenButton)
                        } icon: {
                            AuthenticatorResourcesAsset.Images.circleInformationFill.swiftUIImage
                        }
                    }
                    .padding(.top, value: .large)
                    .accessibilityHint(AuthenticatorResourcesStrings.contentDescriptionButtonExternalLink)

                    Button(AuthenticatorResourcesStrings.continueButton) {
                        // TODO: Migration login flow
                    }
                    .disabled(password.isEmpty)
                    .buttonStyle(.ikBorderedProminent)
                    .ikButtonFullWidth(true)
                    .padding(.vertical, value: .small)
                }
                .listRowInsets(EdgeInsets())
            }
            .headerProminence(.increased)
        }
        .authScrollViewStyle()
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            LoginView(account: PreviewHelper.sampleUIAccount)
        }
}
