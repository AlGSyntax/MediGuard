//
//  Medication.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import Foundation

struct Medication: Identifiable {
    let id = UUID()
    let name: String
    let intakeTime: String
    let nextIntakeDate: String
}
