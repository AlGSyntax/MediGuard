//
//  MealDocumentationViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class MealDocumentationViewModel: ObservableObject {
    @Published var pastWeeks: [PastWeek] = []
    @Published var currentWeek: PastWeek?
    @Published var errorMessage: String = ""
    
    func fetchPastWeeks(userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("pastWeeks")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der vergangenen Wochen: \(error.localizedDescription)"
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine vergangenen Wochen gefunden"
                    return
                }
                self.pastWeeks = documents.compactMap { doc -> PastWeek? in
                    try? doc.data(as: PastWeek.self)
                }
            }
    }

    func fetchCurrentWeek(userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("meals")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der Mahlzeiten: \(error.localizedDescription)"
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine Mahlzeiten gefunden"
                    return
                }
                let allMeals = documents.compactMap { doc -> Meal? in
                    try? doc.data(as: Meal.self)
                }
                self.processMeals(allMeals, userId: userId)
            }
    }

    private func processMeals(_ meals: [Meal], userId: String) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var currentWeekMeals: [Meal] = []
        var pastWeekMeals: [Meal] = []

        for meal in meals {
            if calendar.isDate(meal.intakeDate, equalTo: today, toGranularity: .weekOfYear) {
                currentWeekMeals.append(meal)
            } else {
                pastWeekMeals.append(meal)
            }
        }

        // Save the completed past week if any
        if !pastWeekMeals.isEmpty {
            let pastWeek = groupMealsByWeek(pastWeekMeals).first
            if let pastWeek = pastWeek {
                self.savePastWeek(userId: userId, pastWeek: pastWeek)
            }
        }

        let weekNumber = calendar.component(.weekOfYear, from: today)
        self.currentWeek = PastWeek(weekNumber: weekNumber, meals: currentWeekMeals)

        // Fetch past weeks again to update the view
        self.fetchPastWeeks(userId: userId)
    }

    func savePastWeek(userId: String, pastWeek: PastWeek) {
        let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks").document(pastWeek.id ?? UUID().uuidString)
        
        do {
            try pastWeekRef.setData(from: pastWeek) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Speichern der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                // Update the pastWeeks array
                self.fetchPastWeeks(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der vergangenen Woche: \(error.localizedDescription)"
        }
    }

    private func groupMealsByWeek(_ meals: [Meal]) -> [PastWeek] {
        let calendar = Calendar.current
        var groupedMeals = Dictionary(grouping: meals) { meal -> Int in
            let weekOfYear = calendar.component(.weekOfYear, from: meal.intakeDate)
            return weekOfYear
        }

        return groupedMeals.map { (weekNumber, meals) in
            PastWeek(weekNumber: weekNumber, meals: meals)
        }
    }

    func groupMealsByDay(_ meals: [Meal]) -> [String: [Meal]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let groupedMeals = Dictionary(grouping: meals) { meal -> String in
            formatter.string(from: meal.intakeDate)
        }
        return groupedMeals
    }

    func groupMealsByTime(_ meals: [Meal]) -> [String: [Meal]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let groupedMeals = Dictionary(grouping: meals) { meal -> String in
            formatter.string(from: meal.intakeDate)
        }
        return groupedMeals
    }
}




