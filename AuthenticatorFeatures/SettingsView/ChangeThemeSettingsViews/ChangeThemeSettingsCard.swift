//
//  ChangeThemeSettingsCard.swift
//  Authenticator
//
//  Created by Killian Mathias on 02.04.2026.
//

import SwiftUI

struct ChangeThemeSettingsCard: View {
    let theme: Theme
    @Binding var currentTheme: String
    var body: some View {
        Button {
            UserDefaults.standard.set(theme.rawValue, forKey: "theme")
            currentTheme = theme.rawValue
        } label: {
            HStack {
                ChangeThemeSettingsIndicator(theme: theme)
                Text(theme.localizedName)
                    .foregroundStyle(.foreground)
                Spacer()
                if currentTheme == theme.rawValue {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.foreground)
                }
            }
        }
    }
}

#Preview {
    ChangeThemeSettingsCard(theme: .light, currentTheme: .constant("light"))
}
