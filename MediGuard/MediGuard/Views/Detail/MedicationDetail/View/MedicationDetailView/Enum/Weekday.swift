//
//  Weekday.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import Foundation

// MARK: - Weekday Enum

/**
 Die `Weekday`-Enumeration stellt die Wochentage dar und enthält eine Methode, um den Namen des Wochentags von einer Wochentagsnummer abzuleiten.
 */
enum Weekday: Int, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    /**
     Gibt den Namen des Wochentags zurück.
     
     - Returns: Der Name des Wochentags als String.
     */
    var name: String {
        switch self {
        case .sunday: return "Sonntag"
        case .monday: return "Montag"
        case .tuesday: return "Dienstag"
        case .wednesday: return "Mittwoch"
        case .thursday: return "Donnerstag"
        case .friday: return "Freitag"
        case .saturday: return "Samstag"
        }
    }
    
    /**
     Gibt den Wochentag für eine gegebene Wochentagsnummer zurück.
     
     - Parameter weekday: Die Nummer des Wochentags.
     - Returns: Der entsprechende `Weekday` oder `nil`, wenn die Nummer ungültig ist.
     */
    static func from(_ weekday: Int?) -> Weekday? {
        guard let weekday = weekday else { return nil }
        return Weekday(rawValue: weekday)
    }
}

