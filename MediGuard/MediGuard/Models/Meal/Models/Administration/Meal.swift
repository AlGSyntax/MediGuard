//
//  Meal.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import Foundation
import FirebaseFirestoreSwift

/**
 Repräsentiert eine Mahlzeit mit Eigenschaften zur Speicherung von Mahlzeitendetails.
 
 - Eigenschaften:
    - id: Die eindeutige Kennung für das Mahlzeitdokument in Firestore.
    - name: Der Name der Mahlzeit.
    - intakeDate: Das Datum und die Uhrzeit, wann die Mahlzeit eingenommen wurde.
    - photoURL: Die URL des Fotos, das mit der Mahlzeit verbunden ist, falls vorhanden.
    - description: Eine Beschreibung der Mahlzeit.
 */
struct Meal: Identifiable, Codable {
    /// Die eindeutige Kennung für das Mahlzeitdokument in Firestore.
    @DocumentID var id: String?
    
    /// Der Name der Mahlzeit.
    var name: String
    
    /// Das Datum und die Uhrzeit, wann die Mahlzeit eingenommen wurde.
    var intakeDate: Date
    
    /// Die URL des Fotos, das mit der Mahlzeit verbunden ist, falls vorhanden.
    var photoURL: String?
    
    /// Eine Beschreibung der Mahlzeit.
    var description: String
    
    /**
     Initialisiert eine neue Instanz von `Meal`.
     
     - Parameter id: Die eindeutige Kennung für das Mahlzeitdokument in Firestore. Standardwert ist nil.
     - Parameter name: Der Name der Mahlzeit.
     - Parameter intakeDate: Das Datum und die Uhrzeit, wann die Mahlzeit eingenommen wurde.
     - Parameter photoURL: Die URL des Fotos, das mit der Mahlzeit verbunden ist, falls vorhanden.
     - Parameter description: Eine Beschreibung der Mahlzeit.
     */
    init(id: String? = nil, name: String, intakeDate: Date, photoURL: String?, description: String) {
        self.id = id
        self.name = name
        self.intakeDate = intakeDate
        self.photoURL = photoURL
        self.description = description
    }
}



