//
//  FireUser.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import Foundation


/**
 Das `FireUser`-Modell repräsentiert einen Benutzer in der Firestore-Datenbank.
 
 Es enthält grundlegende Benutzerinformationen und implementiert das `Codable`-Protokoll, um einfache Speicherung und Abruf aus Firestore zu ermöglichen.

 - Eigenschaften:
    - `id`: Die eindeutige Benutzer-ID (String).
    - `name`: Der Name des Benutzers (String).
    - `registeredAt`: Das Datum, an dem der Benutzer sich registriert hat (Date).
 
 - Verwendung:
    ```
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
 */


struct FireUser: Codable {
    var id: String
    var name: String
    var registeredAt: Date
}

