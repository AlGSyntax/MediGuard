//
//  SettingsViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

/**
 Das `SettingsViewModel` verwaltet die Daten und Logik für die Einstellungen der App.
 
 Es enthält Funktionen zum Verwalten und Speichern des Notfallkontakts.

 - Eigenschaften:
    - `emergencyContact`: Eine Zeichenkette, die die gespeicherte Notfallnummer darstellt.
 */
class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var emergencyContact: String
    
    // MARK: - Initializer
    
    /**
     Initialisiert das `SettingsViewModel` und lädt den gespeicherten Notfallkontakt aus den `UserDefaults`.
     
     Wenn kein Notfallkontakt gespeichert ist, wird die Standardnummer "112" verwendet.
     */
    init() {
        emergencyContact = UserDefaults.standard.string(forKey: "emergencyContact") ?? " Notrufnummer eingeben"
    }
    
    // MARK: - Functions
    
    /**
     Speichert den Notfallkontakt in den `UserDefaults`.
     */
    func saveEmergencyContact() {
        UserDefaults.standard.set(emergencyContact, forKey: "emergencyContact")
    }
}


