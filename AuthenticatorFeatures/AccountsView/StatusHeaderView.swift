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
import InfomaniakCoreSwiftUI
import SwiftUI

struct StatusHeaderView: View {
    let type: StatusHeaderType

    private let roundedRectangle = RoundedRectangle(cornerRadius: 24.0)

    var body: some View {
        VStack {
            AuthenticatorLabel(title: type.description, icon: type.icon, iconColor: type.statusColor.foreground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, value: .medium)
        .padding(.horizontal, value: .medium)
        .font(.Token.callout)
        .foregroundStyle(type.statusColor.text)
        .background(type.statusColor.surface, in: roundedRectangle)
        .overlay {
            roundedRectangle
                .stroke(type.statusColor.foreground, lineWidth: 1)
        }
    }

    enum StatusHeaderType {
        case warningAccount
        case errorAccount
        case warningList

        var description: String {
            switch self {
            case .warningList:
                AuthenticatorResourcesStrings.actionRequiredDescription
            case .warningAccount:
                AuthenticatorResourcesStrings.accountNotConnectedWarningTitle
            case .errorAccount:
                AuthenticatorResourcesStrings.errorLoginFailed(001) // TODO: Fetch correct error code
            }
        }

        var icon: Image {
            switch self {
            case .warningList, .warningAccount:
                AuthenticatorResourcesAsset.Images.circleWarning.swiftUIImage
            case .errorAccount:
                AuthenticatorResourcesAsset.Images.triangleWarning.swiftUIImage
            }
        }

        var statusColor: Color.Token.StatusColors {
            guard self != .errorAccount else { return .error }

            return .warning
        }
    }
}

#Preview {
    List {
        Section {} header: {
            StatusHeaderView(type: .errorAccount)
        }
        Section {} header: {
            StatusHeaderView(type: .warningAccount)
        }
        Section {} header: {
            StatusHeaderView(type: .warningList)
        }
    }
    .authListStyle()
}
