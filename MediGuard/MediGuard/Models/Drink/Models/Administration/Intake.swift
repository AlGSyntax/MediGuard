//
//  WaterIntake.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 01.07.24.
//

import Foundation
import FirebaseFirestoreSwift

/**
 Repräsentiert einen Getränkekonsum mit Eigenschaften zur Speicherung von Konsumdetails.
 
 - Eigenschaften:
    - id: Die eindeutige Kennung für das Getränkedokument in Firestore.
    - amount: Die Menge des konsumierten Getränks in Millilitern.
    - type: Der Typ des Getränks (z.B. Wasser, Kaffee, Saft).
    - time: Das Datum und die Uhrzeit, wann das Getränk konsumiert wurde.
    - processed: Ein Boolescher Wert, der angibt, ob der Getränkekonsum verarbeitet wurde.
 */
struct Intake: Identifiable, Codable {
    /// Die eindeutige Kennung für das Getränkedokument in Firestore.
    @DocumentID var id: String?
    
    /// Die Menge des konsumierten Getränks in Millilitern.
    var amount: Int
    
    /// Der Typ des Getränks (z.B. Wasser, Kaffee, Saft).
    var type: String
    
    /// Das Datum und die Uhrzeit, wann das Getränk konsumiert wurde.
    var time: Date
    
    
    
    /**
     Initialisiert eine neue Instanz von `Drink`.
     
     - Parameter id: Die eindeutige Kennung für das Getränkedokument in Firestore. Standardwert ist nil.
     - Parameter amount: Die Menge des konsumierten Getränks in Millilitern.
     - Parameter type: Der Typ des Getränks (z.B. Wasser, Kaffee, Saft).
     - Parameter time: Das Datum und die Uhrzeit, wann das Getränk konsumiert wurde.
     - Parameter processed: Ein Boolescher Wert, der angibt, ob der Getränkekonsum verarbeitet wurde.
     */
    init(id: String? = nil, amount: Int, type: String, time: Date) {
        self.id = id
        self.amount = amount
        self.type = type
        self.time = time
        
    }
}


