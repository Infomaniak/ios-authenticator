//
//  ChangeThemeSettingsCard.swift
//  Authenticator
//
//  Created by Killian Mathias on 02.04.2026.
//

import SwiftUI

struct ChangeThemeSettingsCard: View {
    let theme: Theme
    var body: some View {
        Button {} label: {
            HStack {
                ChangeThemeSettingsIndicator(theme: theme)
                Text(theme.localizedName)
                    .foregroundStyle(.foreground)
            }
        }
    }
}

#Preview {
    ChangeThemeSettingsCard(theme: .light)
}
