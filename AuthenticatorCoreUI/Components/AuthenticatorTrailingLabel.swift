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

public struct AuthenticatorTrailingLabel: View {
    let title: String
    let icon: Image?
    let iconColor: Color?

    private init(title: String, icon: Image, iconColor: Color? = nil) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
    }

    public init(
        _ title: String,
        iconKey: KeyPath<AuthenticatorResourcesAsset.Images.Type, AuthenticatorResourcesImages>,
        iconColor: Color? = nil
    ) {
        let icon = AuthenticatorResourcesAsset.Images.self[keyPath: iconKey].swiftUIImage
        self.init(title: title, icon: icon, iconColor: iconColor)
    }

    public init(
        _ titleKey: KeyPath<AuthenticatorResourcesStrings.Type, String>,
        iconKey: KeyPath<AuthenticatorResourcesAsset.Images.Type, AuthenticatorResourcesImages>,
        iconColor: Color? = nil
    ) {
        let title = AuthenticatorResourcesStrings.self[keyPath: titleKey]
        let icon = AuthenticatorResourcesAsset.Images.self[keyPath: iconKey].swiftUIImage
        self.init(title: title, icon: icon, iconColor: iconColor)
    }

    public var body: some View {
        HStack(spacing: IKPadding.small) {
            Text(title)
                .lineLimit(1)
                .foregroundStyle(Color.Token.Text.primary)
                .font(.Token.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let icon {
                icon
                    .iconSize(.medium)
                    .foregroundStyle(iconColor ?? Color.accentColor)
            }
        }
    }
}
