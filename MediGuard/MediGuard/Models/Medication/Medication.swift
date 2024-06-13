//
//  Medication.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import Foundation
import FirebaseFirestore

struct Medication: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let intakeTime: String
    let nextIntakeDate: String
}
