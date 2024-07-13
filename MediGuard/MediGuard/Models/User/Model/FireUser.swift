//
//  FireUser.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import Foundation

/**
 Das `FireUser`-Modell repräsentiert einen Benutzer in der Firestore-Datenbank.

 Es enthält grundlegende Benutzerinformationen und implementiert das `Codable`-Protokoll, um eine einfache Speicherung und einen einfachen Abruf aus Firestore zu ermöglichen.

 - Eigenschaften:
    - `id`: Die eindeutige Benutzer-ID (String).
    - `name`: Der Name des Benutzers (String).
    - `registeredAt`: Das Datum, an dem der Benutzer sich registriert hat (Date)

 - Bemerkungen:
    - Diese Struktur folgt dem `Codable`-Protokoll, das es ermöglicht, sie einfach in und aus Firestore-Dokumenten zu konvertieren.
    - Die `registeredAt`-Eigenschaft ist ein `Date`-Objekt, das das Registrierungsdatum des Benutzers speichert.
 */
struct FireUser: Codable {
    /// Die eindeutige Benutzer-ID.
    var id: String
    
    /// Der Name des Benutzers.
    var name: String
    
    /// Das Datum, an dem der Benutzer sich registriert hat.
    var registeredAt: Date
    
    /**
     Initialisiert eine neue `FireUser`-Instanz.
     
     - Parameter id: Die eindeutige Benutzer-ID.
     - Parameter name: Der Name des Benutzers.
     - Parameter registeredAt: Das Datum, an dem der Benutzer sich registriert hat.
     */
    init(id: String, name: String, registeredAt: Date) {
        self.id = id
        self.name = name
        self.registeredAt = registeredAt
    }
}


