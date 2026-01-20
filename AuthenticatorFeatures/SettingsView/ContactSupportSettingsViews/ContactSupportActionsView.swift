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
import InfomaniakCoreCommonUI
import SwiftUI

struct ContactSupportActionsView: View {
    @State private var supportPhoneNumber = "+41228203541" // TODO: Fetch by api

    let waitTime: TimeInterval

    var formattedWaitTime: String {
        Duration.seconds(waitTime).formatted(
            .units(allowed: [.hours, .minutes], width: .wide)
        )
    }

    var body: some View {
        VStack(spacing: IKPadding.small) {
            if let phoneUrl = URL(string: "tel://\(supportPhoneNumber)") {
                VStack(spacing: 8) {
                    Link(destination: phoneUrl) {
                        AuthenticatorLabel(\.callButton, iconKey: \.phone, iconColor: .white)
                            .font(.Token.bodyBold)
                    }
                    .buttonStyle(.ikBorderedProminent)
                    .ikButtonFullWidth(true)

                    Text(AuthenticatorResourcesStrings.estimatedWait(formattedWaitTime))
                        .foregroundStyle(Color.Token.Text.secondary)
                        .font(.Token.subheadline)
                }
            }

            Button(AuthenticatorResourcesStrings.submitTicketTitle) {}
                .buttonStyle(.ikBordered)
                .ikButtonFullWidth(true)

            Button(AuthenticatorResourcesStrings.viewGuidesButton) {}
                .buttonStyle(.ikBordered)
                .ikButtonFullWidth(true)
        }
    }
}

#Preview {
    ContactSupportActionsView(waitTime: 1200)
}
