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
    
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
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
    
    /**
        Berechnet das nächste Datum für einen gegebenen Wochentag ab einem bestimmten Datum.
        
        - Parameter weekday: Der gewünschte Wochentag.
        - Parameter date: Das Datum, ab dem gesucht werden soll.
        - Parameter intakeHour: Die Uhrzeit der Einnahme.
        - Parameter intakeMinute: Die Minute der Einnahme.
        - Returns: Das nächste Datum des gewünschten Wochentags.
        */
    static func next(_ weekday: Weekday, after date: Date, intakeHour: Int, intakeMinute: Int) -> Date? {
            let calendar = Calendar.current
            let currentWeekday = calendar.component(.weekday, from: date)
            print("currentWeekday: \(currentWeekday)")

            var daysToAdd = weekday.rawValue - currentWeekday
            print("Initial daysToAdd: \(daysToAdd)")

            if daysToAdd < 0 || (daysToAdd == 0 && calendar.date(bySettingHour: intakeHour, minute: intakeMinute, second: 0, of: date)! < date) {
                daysToAdd += 7
                print("Adjusted daysToAdd (for past time): \(daysToAdd)")
            } else if daysToAdd == 0 {
                if let todayWithTime = calendar.date(bySettingHour: intakeHour, minute: intakeMinute, second: 0, of: date), todayWithTime > date {
                    print("Today's date with intake time: \(todayWithTime)")
                    return todayWithTime
                }
            }

            let nextDate = calendar.date(byAdding: .day, value: daysToAdd, to: date)!
            print("Next date (without time): \(nextDate)")

            let nextDateWithTime = calendar.date(bySettingHour: intakeHour, minute: intakeMinute, second: 0, of: nextDate)!
            print("Next date with intake time: \(nextDateWithTime)")

            return nextDateWithTime
        }
    }








