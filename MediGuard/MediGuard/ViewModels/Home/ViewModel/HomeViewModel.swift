//
//  HomeViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

/**
 Das `HomeViewModel` verwaltet die Daten und Logik für die `HomeView`.
 
 Es enthält Funktionen zur Begrüßung des Benutzers basierend auf der Tageszeit und zur Durchführung eines Notrufs.

 - Eigenschaften:
    - `greeting`: Eine Begrüßungsnachricht, die basierend auf der Tageszeit aktualisiert wird.
 */
class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var greeting: String = ""
    
    // MARK: - Initializer
    
    /**
     Initialisiert das `HomeViewModel` und aktualisiert die Begrüßungsnachricht.
     */
    init() {
        updateGreeting()
    }
    
    // MARK: - Functions
    
    /**
     Aktualisiert die Begrüßungsnachricht basierend auf der aktuellen Tageszeit.
     
     - Es gibt drei mögliche Begrüßungen:
        - "Guten Morgen!" für die Zeit von 5 Uhr bis 12 Uhr.
        - "Guten Tag!" für die Zeit von 12 Uhr bis 16 Uhr.
        - "Guten Abend!" für die Zeit von 16 Uhr bis 5 Uhr.
     */
    func updateGreeting() {
        // Aktuelle Stunde des Tages abrufen
        let hour = Calendar.current.component(.hour, from: Date())
        // Bestimmt die Tageszeit basierend auf der aktuellen Stunde
        let timePeriod = TimePeriod.current(from: hour)
        // Wechselt die Begrüßungsnachricht basierend auf der Tageszeit
        switch timePeriod {
        case .morning:
            greeting = "Guten Morgen,"
        case .afternoon:
            greeting = "Guten Tag,"
        case .evening:
            greeting = "Guten Abend,"
        }
    }
    
    /**
     Führt einen Notruf an die gespeicherte Notfallnummer durch.
     
     - Die Notfallnummer wird aus den `UserDefaults` abgerufen. Wenn keine Notfallnummer gespeichert ist, wird die Standardnummer "112" verwendet.
     - Wenn die Telefonnummer gültig ist und die App sie öffnen kann, wird der Anruf gestartet.
     */
    func callEmergencyContact() {
        let emergencyNumber = UserDefaults.standard.string(forKey: "emergencyContact") ?? "112"
        if let url = URL(string: "tel://\(emergencyNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}






