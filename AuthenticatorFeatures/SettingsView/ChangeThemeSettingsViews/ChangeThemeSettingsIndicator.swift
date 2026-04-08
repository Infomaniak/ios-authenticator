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
import SwiftUI

struct ChangeThemeSettingsIndicator: View {
    @Environment(\.colorScheme) var colorScheme
    let theme: Theme
    var body: some View {
        ZStack {
            switch theme {
            case .light:
                Circle()
                    .foregroundStyle(colorScheme == .light ? Color(uiColor: .systemGroupedBackground) : .white)
            case .dark:
                Circle()
                    .fill(.black)
            case .system:
                ZStack {
                    Circle()
                        .trim(from: 0.5, to: 1)
                        .fill(.black)
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .foregroundStyle(colorScheme == .light ? Color(uiColor: .systemGroupedBackground) : .white)
                }
                .rotationEffect(Angle(degrees: 135))
            }
            Circle()
                .stroke(.ultraThinMaterial, lineWidth: 1)
        }
        .frame(width: 25, height: 25)
    }
}

#Preview {
    ChangeThemeSettingsIndicator(theme: .dark)
}
