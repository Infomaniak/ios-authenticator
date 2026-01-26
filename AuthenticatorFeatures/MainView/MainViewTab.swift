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

import AuthenticatorAccountsView
import AuthenticatorCoreUI
import AuthenticatorResources
import AuthenticatorSettingsView
import SwiftUI

enum MainViewTab: CaseIterable {
        case accounts
        case settings

        var title: String {
            switch self {
            case .accounts:
                AuthenticatorResourcesStrings.accountTitlePlural
            case .settings:
                AuthenticatorResourcesStrings.settingsTitle
            }
        }

        var icon: Image {
            switch self {
            case .accounts:
                AuthenticatorResourcesAsset.Images.house.swiftUIImage
            case .settings:
                AuthenticatorResourcesAsset.Images.gear.swiftUIImage
            }
        }

        public var label: Label<Text, Image> {
            Label(title: { Text(title) }, icon: { icon })
        }

        @MainActor
        @ViewBuilder
        var content: some View {
            switch self {
            case .accounts:
                AccountsView()
            case .settings:
                SettingsView()
            }
        }
    }
