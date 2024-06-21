//
//  Meal.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Meal: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var intakeTime: DateComponents
    var day: String
    var nextIntakeDate: DateComponents?
    var photoURL: String?
    var description: String
    
    init(id: String? = nil, name: String, intakeTime: DateComponents, day: String, nextIntakeDate: DateComponents?, photoURL: String?, description: String) {
        self.id = id
        self.name = name
        self.intakeTime = intakeTime
        self.day = day
        self.nextIntakeDate = nextIntakeDate
        self.photoURL = photoURL
        self.description = description
    }
}

