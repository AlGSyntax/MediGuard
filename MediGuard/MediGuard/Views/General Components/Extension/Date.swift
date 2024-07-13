//
//  Date.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import Foundation

/**
 Eine Erweiterung der `Date`-Struktur, um eine Methode hinzuzufügen, die die Uhrzeit eines `Date`-Objekts auf eine bestimmte Stunde und Minute setzt.
 
 Diese Methode erleichtert die Manipulation von `Date`-Objekten, indem sie eine einfache Möglichkeit bietet, die Uhrzeit eines Datums zu ändern, ohne die ursprüngliche Datumskomponente zu beeinflussen.
 */
extension Date {
    /**
     Setzt die Uhrzeit des `Date`-Objekts auf die angegebene Stunde und Minute.
     
     Diese Methode verwendet den aktuellen Kalender, um die Uhrzeit des Datums zu ändern. Wenn das Setzen der Uhrzeit fehlschlägt, wird das ursprüngliche Datum zurückgegeben.
     
     - Parameter hour: Die Stunde, auf die das Datum gesetzt werden soll (0-23).
     - Parameter minute: Die Minute, auf die das Datum gesetzt werden soll (0-59).
     - Returns: Ein neues `Date`-Objekt mit der geänderten Uhrzeit oder das ursprüngliche Datum, falls das Setzen der Uhrzeit fehlschlägt.
     */
    func setTime(hour: Int, minute: Int) -> Date {
        if let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self) {
            return date
        } else {
            return self
        }
    }
}
