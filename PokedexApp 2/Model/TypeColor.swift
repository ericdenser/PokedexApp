//
//  TypeColor.swift
//  PokedexApp
//
//  Created by Eric on 30/07/25.
//

import SwiftUI


extension Color {
    static func forType(_ typeName: String) -> Color {
        switch typeName {
            case "normal": return .gray
            case "fire": return .orange
            case "water": return .blue
            case "grass": return .green
            case "electric": return .yellow
            case "ice": return .cyan
            case "fighting": return .red
            case "poison": return .purple
            case "ground": return .brown
            case "flying": return .indigo
            case "psychic": return .pink
            case "bug": return .mint
            case "rock": return .brown
            case "ghost": return .indigo
            case "dragon": return .purple
            case "dark": return .black.opacity(0.8)
            case "steel": return .secondary
            case "fairy": return .pink
            default: return .gray.opacity(0.5)
        }
    }
}
