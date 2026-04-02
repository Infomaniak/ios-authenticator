//
//  ChangeThemeSettingsIndicator.swift
//  Authenticator
//
//  Created by Killian Mathias on 02.04.2026.
//

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
