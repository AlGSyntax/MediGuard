//
//  DosageUnit.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 19.06.24.
//

import Foundation

// MARK: - DosageUnit Enum

/**
 Die `DosageUnit`-Enumeration stellt die möglichen Einheiten der Dosierung dar.
 
 Diese Einheiten werden verwendet, um die Dosierung eines Medikaments zu spezifizieren.
 Jede Einheit hat einen Anzeigenamen, der zur Anzeige in der Benutzeroberfläche verwendet wird.
 
 - Eigenschaften:
    - `id`: Die eindeutige Kennung der Dosierungseinheit, basierend auf ihrem Rohwert.
    - `displayName`: Der Anzeigename der Dosierungseinheit zur Verwendung in der Benutzeroberfläche.
 */
enum DosageUnit: String, CaseIterable, Identifiable, Codable {
    case mg
    case ml
    case pills
    
    // MARK: - Identifiable
    var id: String { self.rawValue }
    
    // MARK: - Display Name
    /**
     Gibt den Anzeigenamen der Dosierungseinheit zurück.
     
     - Returns: Der Anzeigename als `String`.
     */
    var displayName: String {
        switch self {
        case .mg:
            return "mg"
        case .ml:
            return "ml"
        case .pills:
            return ""
        }
    }
}




