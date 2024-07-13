//
//  PredefinedTime.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 29.06.24.
//

import SwiftUI

// MARK: - PredefinedTime Enum

/**
 Ein Enum, das die vordefinierten Zeiten enthält.
 */
enum PredefinedMedicationTime: String, CaseIterable {
    case eightAM = "08:00"
    case twelvePM = "12:00"
    case fourPM = "16:00"
    case eightPM = "20:00"
}
