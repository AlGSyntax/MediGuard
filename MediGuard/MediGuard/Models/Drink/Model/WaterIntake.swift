//
//  WaterIntake.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 01.07.24.
//

import Foundation
import FirebaseFirestoreSwift

struct WaterIntake: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var count: Int

    init(id: String? = nil, date: Date, count: Int) {
        self.id = id
        self.date = date
        self.count = count
    }
}

