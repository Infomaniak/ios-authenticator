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
import DesignSystem
import SwiftUI

struct OnboardingProgressBarBottomView: View {
    let title: String

    private init(title: String) {
        self.title = title
    }

    init(_ titleKey: KeyPath<AuthenticatorResourcesStrings.Type, String>) {
        let title = AuthenticatorResourcesStrings.self[keyPath: titleKey]

        self.init(title: title)
    }

    var body: some View {
        VStack(spacing: IKPadding.medium) {
            Text(title)
                .font(.Token.title2)

            ProgressView(value: 0.5) // TODO: Replace with fetched one
                .progressViewStyle(.linear)
        }
        .multilineTextAlignment(.center)
    }
}
