//
//  MedicationColor.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 18.06.24.
//

import SwiftUI

enum MedicationColor: String, Codable, CaseIterable {
    case red
    case green
    case blue
    case yellow
    case orange
    case purple
    case gray // Default fallback color

    var color: Color {
        switch self {
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .yellow:
            return Color.yellow
        case .orange:
            return Color.orange
        case .purple:
            return Color.purple
        case .gray:
            return Color.gray
        }
    }
}

