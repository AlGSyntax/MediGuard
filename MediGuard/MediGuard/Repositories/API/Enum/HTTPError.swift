//
//  HTTPError.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 15.07.24.
//

import Foundation

// MARK: - HTTPError

/**
 Enum zur Definition von HTTP-Fehlern.
 
 Dieses Enum wird verwendet, um spezifische Fehler während der HTTP-Anfragen zu definieren.
 */

enum HTTPError: LocalizedError {
    
    /// Fehler, der auftritt, wenn die URL ungültig ist.
    case invalidURL
    
    /// Fehler, der auftritt, wenn die Request fehlgeschlagen ist.
    case requestFailed
}
