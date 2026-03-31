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
import SwiftUI

struct CenteringPlaceholderAvatarStackView: View {
    let width: CGFloat

    init(
        accounts: [UIAccount],
        size: CGFloat = ConnectedAccountAvatarStackView.defaultSize,
        maxStackSize: Int = ConnectedAccountAvatarStackView.defaultMaxStackSize
    ) {
        width = 0.6 * size * CGFloat(min(maxStackSize, accounts.count))
    }

    var body: some View {
        Color.clear
            .frame(width: width, height: 1)
    }
}
