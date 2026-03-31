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

private struct FewAvatarsAnimationView: View {
    let accounts: [UIAccount]
    let size: CGFloat

    var body: some View {
        HStack(spacing: -size * 0.4) {
            ForEach(accounts.indices, id: \.self) { index in
                ConnectedAccountAvatarView(connectedAccount: accounts[index], size: size)
            }
        }
    }
}

private struct ManyAvatarsAnimationView: View {
    @State private var currentIndex = 0

    let accounts: [UIAccount]
    let size: CGFloat
    let maxStackSize: Int

    init(
        accounts: [UIAccount],
        size: CGFloat = ConnectedAccountAvatarStackView.defaultSize,
        maxStackSize: Int = ConnectedAccountAvatarStackView.defaultMaxStackSize
    ) {
        self.accounts = accounts
        self.size = size
        self.maxStackSize = maxStackSize
    }

    var body: some View {
        ZStack {
            ForEach(accounts.indices, id: \.self) { index in
                ConnectedAccountAvatarView(connectedAccount: accounts[index], size: size)
                    .offset(x: offsetForIndex(index))
                    .scaleEffect(scaleForIndex(index), anchor: .center)
                    .zIndex(normalizedIndex(index) == 1 ? 1 : 0)
                    .animation(Animation.spring(duration: 0.5), value: currentIndex)
                    .opacity(normalizedIndex(index) >= maxStackSize ? 0 : 1)
            }
        }
        .task {
            while !Task.isCancelled && accounts.count > 1 {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                currentIndex = (currentIndex + 1) % accounts.count
            }
        }
    }

    func normalizedIndex(_ index: Int) -> Int {
        let count = accounts.count
        return (index - currentIndex % count + count) % count
    }

    func scaleForIndex(_ index: Int) -> CGFloat {
        guard accounts.count > 1 else {
            return 1.0
        }

        return normalizedIndex(index) == 1 ? 1.0 : 0.75
    }

    func offsetForIndex(_ index: Int) -> CGFloat {
        guard accounts.count > 1 else {
            return 0
        }

        let normalizedIndex = normalizedIndex(index)
        return (CGFloat(normalizedIndex) * size * 0.6) - size * 0.6
    }
}

struct ConnectedAccountAvatarStackView: View {
    static let defaultSize: CGFloat = 32
    static let defaultMaxStackSize = 3

    let accounts: [UIAccount]
    let size: CGFloat
    let maxStackSize: Int

    init(
        accounts: [UIAccount],
        size: CGFloat = ConnectedAccountAvatarStackView.defaultSize,
        maxStackSize: Int = ConnectedAccountAvatarStackView.defaultMaxStackSize
    ) {
        self.accounts = accounts
        self.size = size
        self.maxStackSize = maxStackSize
    }

    var body: some View {
        Group {
            if accounts.count <= 2 {
                FewAvatarsAnimationView(accounts: accounts, size: size)
            } else {
                ManyAvatarsAnimationView(accounts: accounts, size: size)
            }
        }
        .frame(width: 0.6 * size * CGFloat(min(maxStackSize, accounts.count)))
    }
}
