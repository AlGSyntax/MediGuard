//
//  IntakeTypeColor.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.07.24.
//

import SwiftUI

enum IntakeTypeColor: String, CaseIterable {
    case wasser = "Wasser"
    case kaffee = "Kaffee"
    case saft = "Saft"
    case andere = "Andere"

    var color: Color {
        switch self {
        case .wasser:
            return .blue
        case .kaffee:
            return .brown
        case .saft:
            return .orange
        case .andere:
            return .purple
        }
    }
}

