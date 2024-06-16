//
//  AuthenticationMode.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import Foundation

/**
 Das `AuthenticationMode`-Enum definiert die möglichen Authentifizierungsmodi in der App.
 
 Es gibt zwei Modi: Anmeldung (`login`) und Registrierung (`register`). Diese Modi bestimmen den Text und die Aktionen in der `AuthenticationView`.

 - Fälle:
    - `login`: Modus für die Benutzeranmeldung.
    - `register`: Modus für die Benutzerregistrierung.
 
 - Computed Properties:
    - `title`: Der Text für den Hauptbutton, abhängig vom Modus.
    - `alternativeTitle`: Der Text für den Moduswechsel-Button, abhängig vom Modus.
    - `headerText`: Der Header-Text, abhängig vom Modus.
 */
enum AuthenticationMode {
    case login
    case register
    
    // MARK: - Computed Properties
    
    /// Der Text für den Hauptbutton, abhängig vom Modus.
    var title: String {
        switch self {
        case .login:
            return "Anmelden"
        case .register:
            return "Registrieren"
        }
    }
    
    /// Der Text für den Moduswechsel-Button, abhängig vom Modus.
    var alternativeTitle: String {
        switch self {
        case .login:
            return "Noch kein Konto? Registrieren →"
        case .register:
            return "Schon registriert? Anmelden →"
        }
    }
    
    /// Der Header-Text, abhängig vom Modus.
    var headerText: String {
        switch self {
        case .login:
            return "WILLKOMMEN!"
        case .register:
            return "REGISTRIERUNG"
        }
    }
}

