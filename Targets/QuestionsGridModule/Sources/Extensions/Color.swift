//
//  Color.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import SwiftUI

enum ColorPreset: String, CaseIterable {
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case mint = "mint"
    case teal = "teal"
    case cyan = "cyan"
    case blue = "blue"
    case indigo = "indigo"
    case purple = "purple"
    case pink = "pink"
    case brown = "brown"
    case gray = "gray"
    case black = "black"
    case unknown = "unknown"
}

extension Color {

    init(preset: ColorPreset) {
        switch preset {
        case .red: self = .red
        case .orange: self = .orange
        case .yellow: self = .yellow
        case .green: self = .green
        case .mint: self = .mint
        case .teal: self = .teal
        case .cyan: self = .cyan
        case .blue: self = .blue
        case .indigo: self = .indigo
        case .purple: self = .purple
        case .pink: self = .pink
        case .brown: self = .brown
        case .gray: self = .gray
        case .black: self = .black
        case .unknown: self = .clear
        }
    }
}
