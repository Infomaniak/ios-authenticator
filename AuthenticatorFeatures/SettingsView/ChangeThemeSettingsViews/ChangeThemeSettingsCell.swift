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

struct ChangeThemeSettingsCell: View {
    @AppStorage(UserDefaults.shared.key(.theme), store: .shared) private var currentTheme = DefaultPreferences.theme

    let theme: Theme

    var body: some View {
        Button {
            currentTheme = theme
        } label: {
            HStack(spacing: IKPadding.mini) {
                theme.image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)

                Text(theme.localizedName)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if currentTheme == theme {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.foreground)
                        .accessibilityLabel(AuthenticatorResourcesStrings.accessibilityHintCurrentTheme)
                }
            }
            .foregroundStyle(Color.Token.Text.primary)
        }
    }
}

#Preview {
    ChangeThemeSettingsCell(theme: .light)
}
