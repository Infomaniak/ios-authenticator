//
//  Theme.swift
//  Authenticator
//
//  Created by Killian Mathias on 02.04.2026.
//

import Foundation

enum Theme {
    case light
    case dark
    case system
    var localizedName: String {
        switch self {
        case .dark:
            return "Sombre"
        case .light:
            return "Clair"
        case .system:
            return "Système"
        }
    }

    var rawValue: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        case .system:
            return "system"
        }
    }
}
