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
    - `registeredAt`: Das Datum, an dem der Benutzer sich registriert hat (Date).

 - Verwendung:
    ```swift
    // Erstellen eines neuen Benutzers
    let user = FireUser(id: "12345", name: "Alvaro", registeredAt: Date())
    
    // Speichern des Benutzers in Firestore
    do {
        try FirebaseManager.shared.database.collection("users").document(user.id).setData(from: user)
    } catch {
        print("Fehler beim Speichern des Benutzers: \(error)")
    }
    
    // Abrufen eines Benutzers aus Firestore
    FirebaseManager.shared.database.collection("users").document(user.id).getDocument { document, error in
        if let document = document, document.exists {
            do {
                let fetchedUser = try document.data(as: FireUser.self)
                print("Benutzer erfolgreich abgerufen: \(fetchedUser)")
            } catch {
                print("Fehler beim Konvertieren des Dokuments in FireUser: \(error)")
            }
        } else {
            print("Dokument existiert nicht!")
        }
    }
    ```

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
}

