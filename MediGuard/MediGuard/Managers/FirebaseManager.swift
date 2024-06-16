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

 Diese Klasse stellt sicher, dass `Auth`- und `Firestore`-Instanzen nur einmal initialisiert werden und bietet einen zentralen Zugriffspunkt für diese Dienste. Dieser Ansatz folgt den Best Practices für Code-Modularität und Trennung der Zuständigkeiten.

 - Eigenschaften:
    - `shared`: Statische Instanz von `FirebaseManager` für globalen Zugriff.
    - `auth`: Instanz von `Auth` für Authentifizierung.
    - `database`: Instanz von `Firestore` für Datenbank-Interaktionen.

 - Verwendung:
    ```swift
    let firebaseManager = FirebaseManager.shared
    let auth = firebaseManager.auth
    let database = firebaseManager.database
    ```

 - Hinweis: Diese Klasse folgt dem Singleton-Designmuster, um sicherzustellen, dass nur eine Instanz der Klasse existiert und global darauf zugegriffen werden kann.
 */
class FirebaseManager {
    
    /// Statische Instanz von `FirebaseManager` für globalen Zugriff.
    static let shared = FirebaseManager()
    
    /// Instanz von `Auth` für Authentifizierung.
    var auth: Auth
    
    /// Instanz von `Firestore` für Datenbank-Interaktionen.
    var database: Firestore
    
    /**
     Initialisiert eine neue Instanz von `FirebaseManager`.
     
     Diese Methode ist privat, um sicherzustellen, dass die Klasse nur als Singleton verwendet wird.
     */
    private init() {
        self.auth = Auth.auth()
        self.database = Firestore.firestore()
    }
    
  
}

