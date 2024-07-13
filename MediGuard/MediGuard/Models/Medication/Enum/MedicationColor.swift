//
//  MedicationColor.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 18.06.24.
//

import SwiftUI

/**
 Ein Enum zur Darstellung von Farben, die Medikamenten zugewiesen werden können.
 
 Dieses Enum unterstützt die Zuweisung einer Farbe zu einem Medikament und ermöglicht die einfache Konvertierung der Farbnamen in `Color`-Objekte für die Verwendung in SwiftUI.
 
 - Fälle:
    - `red`: Rot
    - `green`: Grün
    - `blue`: Blau
    - `yellow`: Gelb
    - `orange`: Orange
    - `purple`: Lila
    - `gray`: Grau (Standardfarbe)
 */
enum MedicationColor: String, Codable, CaseIterable {
    case red
    case green
    case blue
    case yellow
    case orange
    case purple
    case gray // Default fallback color

    /**
     Eine berechnete Eigenschaft, die die SwiftUI-Farbe für den Enum-Wert zurückgibt.
     
     - Returns: Die SwiftUI `Color`, die dem Enum-Wert entspricht.
     */
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


