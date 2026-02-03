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
import SwiftUI

struct SupportInfoView: View {
    private var supportAvailability: (from: String, to: String) {
        ("06h00", "21h00") // TODO: Get supports availability by API
    }

    var body: some View {
        HStack(spacing: IKPadding.small) {
            AuthenticatorLabel(\.openSupportStatus, iconKey: \.circleFill, iconColor: .Token.Status.valid)

            AuthenticatorLabel(
                AuthenticatorResourcesStrings.daysSupportAvailability(1, 1), // TODO: Get days by API
                iconKey: \.calendar,
                iconColor: .Token.Text.tertiary
            )

            AuthenticatorLabel(
                AuthenticatorResourcesStrings.timeSupportAvailability(supportAvailability.from, supportAvailability.to),
                iconKey: \.clock,
                iconColor: .Token.Text.tertiary
            )
        }
        .font(.Token.body)
        .padding(.vertical, value: .mini)
        .frame(maxWidth: .infinity)
        .background(Color.Token.Surface.secondary.clipShape(.capsule))
    }
}

#Preview {
    SupportInfoView()
}
