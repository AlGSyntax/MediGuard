//
//  Calendar.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import Foundation

/**
 Diese Erweiterung der `Calendar`-Klasse fügt eine Methode hinzu, die eine Kopie des Kalenders zurückgibt,
 deren Zeitzone auf eine bestimmte Stunde gesetzt ist.
 
 - Die Methode `settingHour(_:)` ermöglicht es, die Zeitzone des Kalenders auf eine spezifische Stunde zu setzen.
 */
extension Calendar {
    
    /**
     Gibt eine Kopie des aktuellen Kalenders zurück, dessen Zeitzone auf eine spezifische Stunde gesetzt ist.
     
     - Parameter hour: Die Stunde, auf die die Zeitzone des Kalenders gesetzt werden soll.
     - Returns: Eine Kopie des Kalenders mit der Zeitzone, die auf die angegebene Stunde gesetzt ist.
     
     - Beispiel:
        ```swift
        let calendar = Calendar.current
        let modifiedCalendar = calendar.settingHour(3)
        ```
        Dieser Code erstellt eine Kopie des aktuellen Kalenders und setzt dessen Zeitzone auf GMT+3.
     */
    func settingHour(_ hour: Int) -> Calendar {
        // Erstellt eine Kopie des aktuellen Kalenders
        var calendar = self
        
        // Setzt die Zeitzone der Kalenderkopie auf die angegebene Stunde
        calendar.timeZone = TimeZone(secondsFromGMT: 3600 * hour) ?? .current
        
        // Gibt die modifizierte Kalenderkopie zurück
        return calendar
    }
}


