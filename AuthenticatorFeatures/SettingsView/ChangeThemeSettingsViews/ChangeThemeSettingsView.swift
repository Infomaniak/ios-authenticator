//
//  ChangeThemeSettingsView.swift
//  Authenticator
//
//  Created by Killian Mathias on 01.04.2026.
//

import SwiftUI

struct ChangeThemeSettingsView: View {
    var body: some View {
        Form {
            ChangeThemeSettingsCard(theme: .light)
            ChangeThemeSettingsCard(theme: .dark)
            ChangeThemeSettingsCard(theme: .system)
        }
        .navigationTitle("Thème")
    }
}

#Preview {
    ChangeThemeSettingsView()
}
