//
//  MediGuardApp.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI
import Firebase

/**
 Die `MediGuardApp`-Struktur ist der Haupteinstiegspunkt der App und konfiguriert Firebase bei der Initialisierung.
 
 Diese Struktur entscheidet auch, welche View (`HomeView` oder `AuthenticationView`) basierend auf dem Anmeldestatus des Benutzers angezeigt wird.

 - Eigenschaften:
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Authentifizierungslogik und -daten verwaltet.
 */
@main
struct MediGuardApp: App {
    
    // MARK: - Initializer
    
    /**
     Initialisiert die App und konfiguriert Firebase.
     */
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    // MARK: - Variables
    
    @StateObject private var userViewModel = UserViewModel()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            // Entscheidet, welche View basierend auf dem Anmeldestatus des Benutzers angezeigt wird
            if userViewModel.userIsLoggedIn {
                // Zeigt die HomeView an, wenn der Benutzer angemeldet ist
                HomeView()
                    .environmentObject(userViewModel)
            } else {
                // Zeigt die AuthenticationView an, wenn der Benutzer nicht angemeldet ist
                AuthenticationView()
                    .environmentObject(userViewModel)
            }
        }
    }
}

