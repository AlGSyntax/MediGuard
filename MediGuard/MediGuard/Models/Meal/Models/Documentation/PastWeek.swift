//
//  PastWeek.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import Foundation
import FirebaseFirestoreSwift

/**
 Eine Struktur zur Darstellung einer vergangenen Woche mit ihren Mahlzeiten.

 Diese Struktur wird verwendet, um die Daten einer vergangenen Woche zu speichern, einschließlich der Wochennummer und der Liste der Mahlzeiten.
 Sie implementiert das `Identifiable`-Protokoll, um in SwiftUI-Listen verwendet werden zu können, und das `Codable`-Protokoll, um einfach mit Firestore gespeichert und abgerufen werden zu können.

 - Eigenschaften:
    - id: Die eindeutige ID der Woche, wie sie in Firestore gespeichert wird. Kann `nil` sein, wenn die Woche noch nicht gespeichert wurde.
    - weekNumber: Die Nummer der Woche im Jahr.
    - meals: Eine Liste von Mahlzeiten, die in dieser Woche eingenommen wurden.
 */
struct PastWeek: Identifiable, Codable {
    /// Die eindeutige ID der Woche, wie sie in Firestore gespeichert wird. Kann `nil` sein, wenn die Woche noch nicht gespeichert wurde.
    @DocumentID var id: String?
    
    /// Die Nummer der Woche im Jahr.
    var weekNumber: Int
    
    /// Eine Liste von Mahlzeiten, die in dieser Woche eingenommen wurden.
    var meals: [Meal]

    /**
     Initialisiert eine neue Instanz von `PastWeek`.

     - Parameter id: Die eindeutige ID der Woche, wie sie in Firestore gespeichert wird. Standardwert ist `nil`.
     - Parameter weekNumber: Die Nummer der Woche im Jahr.
     - Parameter meals: Eine Liste von Mahlzeiten, die in dieser Woche eingenommen wurden.
     */
    init(id: String? = nil, weekNumber: Int, meals: [Meal]) {
        self.id = id
        self.weekNumber = weekNumber
        self.meals = meals
    }
}



