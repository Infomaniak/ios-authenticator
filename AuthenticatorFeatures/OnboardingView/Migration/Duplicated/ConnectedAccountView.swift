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
import InfomaniakCore
import InfomaniakCoreSwiftUI
import Nuke
import NukeUI
import SwiftUI

struct ConnectedAccountAvatarView: View {
    let connectedAccount: UIAccount
    var size: CGFloat = 40

    var body: some View {
        Group {
            if let avatarURL = connectedAccount.profilePictureURL {
                LazyImage(request: ImageRequest(url: avatarURL)) { state in
                    if let image = state.image {
                        AvatarImage(image: image, size: size)
                    } else {
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .clipShape(Circle())
        .background(
            Circle()
                .stroke(Color.Token.Surface.tertiary)
        )
    }

    private var initialsView: some View {
        InitialsView(
            initials: NameFormatter(fullName: connectedAccount.name).initials,
            backgroundColor: Color.backgroundColor(from: connectedAccount.email.hash),
            foregroundColor: Color.white,
            size: size
        )
    }
}
