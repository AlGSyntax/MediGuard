//
//  Week.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.07.24.
//

import Foundation
import FirebaseFirestoreSwift

/**
 Repräsentiert eine Woche mit einer Liste von Getränkeeinnahmen.
 
 - Eigenschaften:
    - id: Die eindeutige Kennung für das Wochendokument in Firestore.
    - weekNumber: Die Nummer der Woche im Jahr.
    - intakes: Eine Liste der Getränkeeinnahmen in dieser Woche.
 */
struct Week: Identifiable, Codable {
    /// Die eindeutige Kennung für das Wochendokument in Firestore.
    @DocumentID var id: String?
    
    /// Die Nummer der Woche im Jahr.
    var weekNumber: Int
    
    /// Eine Liste der Getränkeeinnahmen in dieser Woche.
    var intakes: [Intake]
    
    /**
     Initialisiert eine neue Instanz von `Week`.
     
     - Parameter id: Die eindeutige Kennung für das Wochendokument in Firestore. Standardwert ist nil.
     - Parameter weekNumber: Die Nummer der Woche im Jahr.
     - Parameter intakes: Eine Liste der Getränkeeinnahmen in dieser Woche.
     */
    init(id: String? = nil, weekNumber: Int, intakes: [Intake]) {
        self.id = id
        self.weekNumber = weekNumber
        self.intakes = intakes
    }
}

