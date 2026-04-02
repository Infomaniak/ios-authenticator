//
//  ChangeThemeSettingsView.swift
//  Authenticator
//
//  Created by Killian Mathias on 01.04.2026.
//

import AuthenticatorCore
import SwiftUI

struct ChangeThemeSettingsView: View {
    @State private var currentTheme = UserDefaults.standard.value(forKeyPath: "theme") as! String
    var body: some View {
        Form {
            ChangeThemeSettingsCard(theme: .light, currentTheme: $currentTheme)
            ChangeThemeSettingsCard(theme: .dark, currentTheme: $currentTheme)
            ChangeThemeSettingsCard(theme: .system, currentTheme: $currentTheme)
        }
        .navigationTitle("Thème")
    }
}

#Preview {
    ChangeThemeSettingsView()
}
