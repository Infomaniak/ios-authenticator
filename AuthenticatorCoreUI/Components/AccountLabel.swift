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

import InfomaniakCore
import InfomaniakCoreSwiftUI
import NukeUI
import SwiftUI

public struct AccountLabel: View {
    let account: UIAccount
    let size: Size

    public init(account: UIAccount, size: Size) {
        self.account = account
        self.size = size
    }

    public var body: some View {
        HStack {
            LazyImage(url: account.profilePictureURL) { state in
                if let image = state.image {
                    AvatarImage(image: image, size: size.iconSize)
                } else {
                    InitialsView(
                        initials: NameFormatter(fullName: account.name).initials,
                        backgroundColor: Color.backgroundColor(from: account.hashValue),
                        foregroundColor: Color.Token.Text.coloredBackground,
                        size: size.iconSize
                    )
                }
            }
            .frame(width: size.iconSize, height: size.iconSize)

            VStack(alignment: .leading) {
                Text(account.name)
                    .font(size.nameFont)

                Text(account.email)
                    .font(size.emailFont)
                    .foregroundStyle(Color.Token.Text.tertiary)
            }
        }
    }

    public enum Size {
        case small
        case large

        var iconSize: CGFloat {
            switch self {
            case .small:
                40
            case .large:
                44
            }
        }

        var nameFont: Font {
            switch self {
            case .small:
                .Token.headline
            case .large:
                .Token.title2
            }
        }

        var emailFont: Font {
            switch self {
            case .small:
                .Token.callout
            case .large:
                .Token.subheadline
            }
        }
    }
}

#Preview {
    AccountLabel(account: PreviewHelper.sampleUIAccount, size: .small)
}
