//
//  AuthenticationError.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.06.24.
//

import Foundation

/**
 Das `AuthenticationError`-Enum beschreibt mögliche Authentifizierungsfehler, die während der Benutzer-Authentifizierung auftreten können.

 Dieses Enum implementiert die Protokolle `Error`, `LocalizedError` und `Identifiable`, um eine einfache Fehlerbehandlung und Lokalisierung zu ermöglichen.

 - Fehlerfälle:
    - `invalidEmailOrPassword`: Der Benutzername oder das Passwort ist falsch.
    - `emailAlreadyInUse`: Der Benutzername wird bereits verwendet.
    - `unknownError`: Ein unbekannter Fehler ist aufgetreten.
    - `networkError`: Ein Netzwerkfehler ist aufgetreten.
    - `sessionExpired`: Die Sitzung ist abgelaufen.
    - `tooManyRequests`: Zu viele Anfragen wurden gesendet.
 */
enum AuthenticationError: Error, LocalizedError, Identifiable {
    
    // MARK: - Fehlerfälle
    
    case invalidEmailOrPassword
    case emailAlreadyInUse
    case unknownError
    case networkError
    case sessionExpired
    case tooManyRequests

    // MARK: - Identifiable
    
    /// Eindeutige ID für den Fehler.
    var id: String {
        UUID().uuidString
    }

    // MARK: - LocalizedError
    
    /// Lokalisierte Beschreibung des Fehlers.
    var errorDescription: String? {
        switch self {
        case .invalidEmailOrPassword:
            return "Name oder Passwort ist falsch."
        case .emailAlreadyInUse:
            return "Dieser Name wird bereits verwendet."
        case .unknownError:
            return "Ein unbekannter Fehler ist aufgetreten. Bitte versuchen Sie es erneut."
        case .networkError:
            return "Netzwerkfehler. Bitte überprüfen Sie Ihre Internetverbindung."
        case .sessionExpired:
            return "Sitzung abgelaufen. Bitte melden Sie sich erneut an."
        case .tooManyRequests:
            return "Zu viele Anfragen. Bitte versuchen Sie es später erneut."
        }
    }
}






