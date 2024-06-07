//
//  FirebaseManager.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/**
 Die `FirebaseManager`-Klasse ist ein Singleton, das die Konfiguration und Verwaltung der in der App verwendeten Firebase-Dienste zentralisiert.

 Sie stellt sicher, dass `Auth`- und `Firestore`-Instanzen nur einmal initialisiert werden und bietet einen zentralen Zugriffspunkt für diese Dienste. Dieser Ansatz folgt den Best Practices für Code-Modularität und Trennung der Zuständigkeiten.

 - Eigenschaften:
    - `shared`: Statische Instanz von `FirebaseManager` für globalen Zugriff.
    - `auth`: Instanz von `Auth` für Authentifizierung.
    - `database`: Instanz von `Firestore` für Datenbank-Interaktionen.
    - `userId`: Optionale Zeichenkette, die die UID des aktuell authentifizierten Benutzers enthält.

 - Verwendung:
    ```
    let firebaseManager = FirebaseManager.shared
    let userId = firebaseManager.userId
    let auth = firebaseManager.auth
    let database = firebaseManager.database
    ```
 */

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    
    
    var userId:String? {
        auth.currentUser?.uid
    }
    
}
