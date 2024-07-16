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
    - `nameViewModel`: Das `NameViewModel`-Objekt, das die Namensverarbeitung und -vorschläge verwaltet.
 
 - Initializer:
    - `init()`: Initialisiert die App und konfiguriert Firebase. Fordert auch die Berechtigung für Benachrichtigungen an.
 
 - Private Methoden:
    - `requestNotificationAuthorization()`: Fordert die Berechtigung für Benachrichtigungen vom Benutzer an.
 
 - Scene:
    - `body`: Entscheidet basierend auf dem Anmeldestatus des Benutzers, welche View angezeigt wird. Die entsprechenden ViewModel-Objekte werden als EnvironmentObjects bereitgestellt.
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
        requestNotificationAuthorization()
       
    }
    
    // MARK: - Variables
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var cityViewModel = CityViewModel()
    
    // MARK: - Private Methods
    
    /**
         Fordert die Berechtigung für Benachrichtigungen vom Benutzer an.
         */
    private func requestNotificationAuthorization() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error)")
                }
                print(granted)
            }
        }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            // Entscheidet, welche View basierend auf dem Anmeldestatus des Benutzers angezeigt wird
            if userViewModel.userIsLoggedIn {
                // Zeigt die HomeView an, wenn der Benutzer angemeldet ist
                withAnimation(.easeInOut(duration: 0.7)) {
                    HomeView()
                        .transition(.move(edge: .leading))
                        .environmentObject(userViewModel)
                        .environmentObject(cityViewModel)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.7)) {
                    // Zeigt die AuthenticationView an, wenn der Benutzer nicht angemeldet ist
                    AuthenticationView()
                        .transition(.move(edge: .leading))
                        .environmentObject(userViewModel)
                        .environmentObject(cityViewModel)
                }
            }
        }
    }
    
    
    
}

