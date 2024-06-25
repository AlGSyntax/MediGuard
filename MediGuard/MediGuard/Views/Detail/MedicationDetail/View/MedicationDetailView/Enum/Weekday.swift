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
enum Weekday: Int, Codable, CaseIterable, Hashable {
    
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    /**
     Gibt den Namen des Wochentags zurück.
     
     - Returns: Der Name des Wochentags als String.
     */
    var name: String {
        switch self {
        
        case .monday: return "Montag"
        case .tuesday: return "Dienstag"
        case .wednesday: return "Mittwoch"
        case .thursday: return "Donnerstag"
        case .friday: return "Freitag"
        case .saturday: return "Samstag"
        case .sunday: return "Sonntag"
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

