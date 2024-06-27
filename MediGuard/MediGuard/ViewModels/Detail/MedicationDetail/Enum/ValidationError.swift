//
//  ValidationError.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 27.06.24.
//

import Foundation

// MARK: - ValidationError Enum

/**
 Ein Enum, das verschiedene Arten von Validierungsfehlern repräsentiert, die bei der Verwaltung von Medikamenten auftreten können.
 
 Diese Fehler können verwendet werden, um spezifische Fehlermeldungen zu generieren, die dem Benutzer angezeigt werden.
 
 - Fehlerfälle:
    - emptyName: Der Name des Medikaments darf nicht leer sein.
    - duplicateMedication: Ein Medikament mit diesem Namen und dieser Uhrzeit existiert bereits.
    - invalidTime: Die Uhrzeit ist ungültig.
    - other: Ein anderer Fehler, der eine benutzerdefinierte Fehlermeldung enthält.
 */
enum ValidationError: Error, LocalizedError {
    case emptyName
    case duplicateMedication
    case invalidTime
    case other(String)

    // MARK: - Error Description

    /**
     Eine berechnete Eigenschaft, die eine Beschreibung des Fehlers zurückgibt.
     
     Diese Beschreibung kann verwendet werden, um dem Benutzer eine verständliche Fehlermeldung anzuzeigen.
     */
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Der Name des Medikaments darf nicht leer sein."
        case .duplicateMedication:
            return "Ein Medikament mit diesem Namen und dieser Uhrzeit existiert bereits."
        case .invalidTime:
            return "Die Uhrzeit ist ungültig."
        case .other(let message):
            return message
        }
    }
}


