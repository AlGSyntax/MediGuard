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
    var name: String
    var intakeTime: String
    var nextIntakeDate: String
}
