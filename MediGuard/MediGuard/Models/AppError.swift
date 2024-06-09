//
//  AppError.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.06.24.
//

import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let message: String
}
