//
//  PastWeek.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import Foundation
import FirebaseFirestoreSwift

struct PastWeek: Identifiable, Codable {
    @DocumentID var id: String?
    var weekNumber: Int
    var meals: [Meal]

    init(id: String? = nil, weekNumber: Int, meals: [Meal]) {
        self.id = id
        self.weekNumber = weekNumber
        self.meals = meals
    }
}


