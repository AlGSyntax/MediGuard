//
//  AuthenticationError.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.06.24.
//

import Foundation

enum AuthenticationError: Error, LocalizedError, Identifiable {
    case invalidEmailOrPassword
    case emailAlreadyInUse
    case unknownError
    case networkError
    case sessionExpired
    case tooManyRequests

    var id: String {
        UUID().uuidString
    }

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





