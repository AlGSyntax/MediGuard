//
//  AuthenticationMode.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import Foundation

enum AuthenticationMode {
    case login, register
    
    
    var title: String {
        switch self {
        case .login: return "Anmelden"
        case .register: return "Registrieren"
        }
    }
    
    var alternativeTitle: String {
        switch self {
        case .login: return "Noch kein Konto? Registrieren →"
        case .register: return "Schon registriert? Anmelden →"
        }
    }
    
    var headerText: String {
        switch self{
        case .login: return "WILLKOMMEN!"
        case .register: return "REGISTRIERUNG"
        }
    }
}
