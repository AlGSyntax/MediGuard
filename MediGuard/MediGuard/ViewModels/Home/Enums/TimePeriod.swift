//
//  TimePeriod.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import Foundation

/**
 Das `TimePeriod`-Enum repräsentiert die verschiedenen Tageszeiten.
 
 Es wird verwendet, um die Begrüßungsnachricht basierend auf der aktuellen Uhrzeit zu bestimmen.

 - Fälle:
    - `morning`: Repräsentiert die Zeit von 5 Uhr bis 12 Uhr.
    - `afternoon`: Repräsentiert die Zeit von 12 Uhr bis 16 Uhr.
    - `evening`: Repräsentiert die Zeit von 16 Uhr bis 5 Uhr.
 */
enum TimePeriod {
    case morning
    case afternoon
    case evening
    
    /**
     Bestimmt die aktuelle Tageszeit basierend auf der gegebenen Stunde.
     
     - Parameter hour: Die aktuelle Stunde als Integer.
     - Returns: Die entsprechende Tageszeit als `TimePeriod`.
     */
    static func current(from hour: Int) -> TimePeriod {
        switch hour {
        case 5..<12:
            return .morning
        case 12..<16:
            return .afternoon
        default:
            return .evening
        }
    }
}

