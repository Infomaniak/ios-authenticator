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
import InfomaniakCoreSwiftUI
import SwiftUI

public struct StatusHeaderView: View {
    let type: StatusHeaderType

    let description: String
    let primaryButton: (title: String, action: () -> Void)?
    let secondaryButton: (title: String, action: () -> Void)?

    private let roundedRectangle = RoundedRectangle(cornerRadius: 24.0)

    public init(
        type: StatusHeaderType,
        description: String,
        primaryButton: (title: String, action: () -> Void)? = nil,
        secondaryButton: (title: String, action: () -> Void)? = nil
    ) {
        self.type = type
        self.description = description
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public var body: some View {
        VStack(spacing: IKPadding.medium) {
            AuthenticatorLabel(title: description, icon: type.icon, iconColor: type.statusColor.foreground)
                .frame(maxWidth: .infinity, alignment: .leading)

            if primaryButton != nil || secondaryButton != nil {
                VStack(spacing: IKPadding.small) {
                    if let primaryButton {
                        Button(primaryButton.title, action: primaryButton.action)
                            .buttonStyle(.ikBordered)
                    }

                    if let secondaryButton {
                        Button(secondaryButton.title, action: secondaryButton.action)
                            .buttonStyle(.ikBorderless)
                    }
                }
                .font(.Token.bodyBold)
                .ikButtonFullWidth(true)
            }
        }
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

    public enum StatusHeaderType {
        case suggestion
        case warning
        case error

        var icon: Image {
            switch self {
            case .suggestion:
                AuthenticatorResourcesAsset.Images.circleInformation.swiftUIImage
            case .warning:
                AuthenticatorResourcesAsset.Images.circleExclamationmark.swiftUIImage
            case .error:
                AuthenticatorResourcesAsset.Images.triangleExclamationmark.swiftUIImage
            }
        }

        var statusColor: Color.Token.StatusColors {
            switch self {
            case .suggestion:
                .suggestion
            case .warning:
                .warning
            case .error:
                .error
            }
        }
    }
}

#Preview {
    List {
        Section {} header: {
            StatusHeaderView(type: .suggestion,
                             description: "Suggestion description",
                             primaryButton: ("Action", {}))
        }
        Section {} header: {
            StatusHeaderView(type: .warning,
                             description: "Warning description",
                             primaryButton: ("Action", {}),
                             secondaryButton: ("Action", {}))
        }
        Section {} header: {
            StatusHeaderView(type: .error,
                             description: "Error description")
        }
    }
    .authListStyle()
}
