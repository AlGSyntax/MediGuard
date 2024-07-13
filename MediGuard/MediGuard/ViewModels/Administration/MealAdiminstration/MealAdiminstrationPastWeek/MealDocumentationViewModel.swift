//
//  MealDocumentationViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

/**
 ViewModel zur Verwaltung der Dokumentation von Mahlzeiten.
 
 Dieses ViewModel bietet Funktionen zum Abrufen, Verarbeiten und Gruppieren von Mahlzeiten, die in Firestore gespeichert sind.
 Es verwaltet auch Fehlermeldungen und stellt die Daten für die aktuelle Woche und vergangene Wochen bereit.
 */
@MainActor
class MealDocumentationViewModel: ObservableObject {
    // MARK: - Properties
    
    /// Eine Liste der vergangenen Wochen mit ihren Mahlzeiten.
    @Published var pastWeeks: [PastWeek] = []
    
    /// Die Mahlzeiten der aktuellen Woche.
    @Published var currentWeek: PastWeek?
    
    /// Eine Fehlermeldung, die bei einem Fehler gesetzt wird.
    @Published var errorMessage: String = ""

    // MARK: - Fetch Methods
    
    /**
     Ruft die vergangenen Wochen für einen bestimmten Benutzer aus Firestore ab.
     
     - Parameter userId: Die ID des Benutzers, dessen vergangene Wochen abgerufen werden sollen.
     */
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

    /**
     Ruft die Mahlzeiten der aktuellen Woche für einen bestimmten Benutzer aus Firestore ab.
     
     - Parameter userId: Die ID des Benutzers, dessen Mahlzeiten abgerufen werden sollen.
     */
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

    // MARK: - Processing Methods
    
    /**
     Verarbeitet die abgerufenen Mahlzeiten und teilt sie in aktuelle und vergangene Wochen auf.
     
     - Parameter meals: Die Liste der abgerufenen Mahlzeiten.
     - Parameter userId: Die ID des Benutzers, dessen Mahlzeiten verarbeitet werden sollen.
     */
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

            if !pastWeekMeals.isEmpty {
                let pastWeek = groupMealsByWeek(pastWeekMeals).first
                if let pastWeek = pastWeek {
                    // Verhindern Sie doppelte Einträge
                    self.checkAndSavePastWeek(userId: userId, pastWeek: pastWeek)
                }
            }

            let weekNumber = calendar.component(.weekOfYear, from: today)
            self.currentWeek = PastWeek(weekNumber: weekNumber, meals: currentWeekMeals)
        }

        private func checkAndSavePastWeek(userId: String, pastWeek: PastWeek) {
            let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks")
                .whereField("weekNumber", isEqualTo: pastWeek.weekNumber)
            
            pastWeekRef.getDocuments { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Überprüfen der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                
                if querySnapshot?.documents.isEmpty == true {
                    self.savePastWeek(userId: userId, pastWeek: pastWeek)
                } else {
                    self.errorMessage = "Woche \(pastWeek.weekNumber) ist bereits gespeichert."
                }
            }
        }

    // MARK: - Save Method
    
    /**
     Speichert eine vergangene Woche in Firestore.
     
     - Parameter userId: Die ID des Benutzers, dessen vergangene Woche gespeichert werden soll.
     - Parameter pastWeek: Die zu speichernde vergangene Woche.
     */
    func savePastWeek(userId: String, pastWeek: PastWeek) {
        let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks").document(pastWeek.id ?? UUID().uuidString)
        
        do {
            try pastWeekRef.setData(from: pastWeek) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Speichern der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                // Aktualisiere das Array der vergangenen Wochen
                self.fetchPastWeeks(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der vergangenen Woche: \(error.localizedDescription)"
        }
    }

    // MARK: - Grouping Methods
    
    /**
     Gruppiert die Mahlzeiten nach Woche.
     
     - Parameter meals: Die zu gruppierenden Mahlzeiten.
     - Returns: Eine Liste von `PastWeek`-Objekten, die die Mahlzeiten nach Woche gruppiert enthalten.
     */
    private func groupMealsByWeek(_ meals: [Meal]) -> [PastWeek] {
        let calendar = Calendar.current
        let groupedMeals = Dictionary(grouping: meals) { meal -> Int in
            let weekOfYear = calendar.component(.weekOfYear, from: meal.intakeDate)
            return weekOfYear
        }

        return groupedMeals.map { (weekNumber, meals) in
            PastWeek(weekNumber: weekNumber, meals: meals)
        }
    }

    /**
     Gruppiert die Mahlzeiten nach Tag.
     
     - Parameter meals: Die zu gruppierenden Mahlzeiten.
     - Returns: Ein Dictionary, das die Mahlzeiten nach Tag gruppiert enthält.
     */
    func groupMealsByDay(_ meals: [Meal]) -> [String: [Meal]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let groupedMeals = Dictionary(grouping: meals) { meal -> String in
            formatter.string(from: meal.intakeDate)
        }
        return groupedMeals
    }

    /**
     Gruppiert die Mahlzeiten nach Uhrzeit.
     
     - Parameter meals: Die zu gruppierenden Mahlzeiten.
     - Returns: Ein Dictionary, das die Mahlzeiten nach Uhrzeit gruppiert enthält.
     */
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






