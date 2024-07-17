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
            // Initialisiert ein Kalender-Objekt
            let calendar = Calendar.current
        
            // Setzt das heutige Datum auf den Start des Tages
            let today = calendar.startOfDay(for: Date())
            
            // Arrays zur Speicherung der Mahlzeiten der aktuellen Woche und der vergangenen Wochen
            var currentWeekMeals: [Meal] = []
            var pastWeekMeals: [Meal] = []
            
            // Iteriert über jede Mahlzeit
            for meal in meals {
                // Überprüft, ob die Mahlzeit in der aktuellen Woche liegt
                if calendar.isDate(meal.intakeDate, equalTo: today, toGranularity: .weekOfYear) {
                    currentWeekMeals.append(meal)// Fügt die Mahlzeit zur aktuellen Woche hinzu
                } else {
                    // Fügt die Mahlzeit zu den vergangenen Wochen hinzu
                    pastWeekMeals.append(meal)
                }
            }
            
            // Überprüft, ob es vergangene Wochen gibt
            if !pastWeekMeals.isEmpty {
                // Gruppiert die Mahlzeiten der vergangenen Woche nach Woche und nimmt die erste Woche
                let pastWeek = groupMealsByWeek(pastWeekMeals).first
                if let pastWeek = pastWeek {
                    // Verhindert doppelte Einträge, indem die vergangene Woche überprüft und gespeichert wird
                    self.checkAndSavePastWeek(userId: userId, pastWeek: pastWeek)
                }
            }
            
        // Bestimmt die Wochennummer der aktuellen Woche
            let weekNumber = calendar.component(.weekOfYear, from: today)
        
        // Setzt die Mahlzeiten der aktuellen Woche
            self.currentWeek = PastWeek(weekNumber: weekNumber, meals: currentWeekMeals)
        }
        
    /**
     Überprüft, ob eine vergangene Woche bereits in Firestore gespeichert ist, und speichert sie falls nicht.
     
     - Parameter userId: Die ID des Benutzers, dessen vergangene Woche gespeichert werden soll.
     - Parameter pastWeek: Die zu speichernde vergangene Woche.
     */
        private func checkAndSavePastWeek(userId: String, pastWeek: PastWeek) {
            
            // Referenziert die Sammlung der vergangenen Wochen des Benutzers in Firestore
            let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks")
                .whereField("weekNumber", isEqualTo: pastWeek.weekNumber)
            
            // Ruft die Dokumente der vergangenen Woche ab
            pastWeekRef.getDocuments { querySnapshot, error in
                // Überprüft auf Fehler beim Abrufen der Dokumente
                if let error = error {
                    self.errorMessage = "Fehler beim Überprüfen der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                
                // Überprüft, ob die Dokumente der vergangenen Woche leer sind
                if querySnapshot?.documents.isEmpty == true {
                    // Speichert die vergangene Woche, wenn sie nicht bereits vorhanden ist
                    self.savePastWeek(userId: userId, pastWeek: pastWeek)
                } else {
                    // Setzt eine Fehlermeldung, wenn die Woche bereits gespeichert ist
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
        // Referenziert das Dokument der vergangenen Woche im Firestore
        let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks").document(pastWeek.id ?? UUID().uuidString)
        
        do {
            // Versucht, die Daten der vergangenen Woche in Firestore zu speichern
            try pastWeekRef.setData(from: pastWeek) { error in
                // Überprüft, ob beim Speichern ein Fehler aufgetreten ist
                if let error = error {
                    self.errorMessage = "Fehler beim Speichern der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                // Aktualisiert das Array der vergangenen Wochen
                self.fetchPastWeeks(userId: userId)
            }
        } catch let error {
            // Setzt die Fehlermeldung, wenn das Serialisieren der Daten fehlgeschlagen ist
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
        
        // Initialisiert ein Kalender-Objekt
        let calendar = Calendar.current
        
        // Gruppiert die Mahlzeiten nach der Wochennummer
        let groupedMeals = Dictionary(grouping: meals) { meal -> Int in
            let weekOfYear = calendar.component(.weekOfYear, from: meal.intakeDate)
            return weekOfYear
        }
        
        // Konvertiert das Dictionary der gruppierten Mahlzeiten in eine Liste von `PastWeek`-Objekten
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
        // Initialisiert ein DateFormatter-Objekt zur Formatierung der Datumsangaben
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        // Gruppiert die Mahlzeiten nach dem formatierten Datum (Tag)
        let groupedMeals = Dictionary(grouping: meals) { meal -> String in
            formatter.string(from: meal.intakeDate)
        }
        
        // Gibt das Dictionary der gruppierten Mahlzeiten zurück
        return groupedMeals
    }

    /**
     Gruppiert die Mahlzeiten nach Uhrzeit.
     
     - Parameter meals: Die zu gruppierenden Mahlzeiten.
     - Returns: Ein Dictionary, das die Mahlzeiten nach Uhrzeit gruppiert enthält.
     */
    func groupMealsByTime(_ meals: [Meal]) -> [String: [Meal]] {
        // Initialisiert ein DateFormatter-Objekt zur Formatierung der Uhrzeiten
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        // Gruppiert die Mahlzeiten nach der formatierten Uhrzeit
        let groupedMeals = Dictionary(grouping: meals) { meal -> String in
            formatter.string(from: meal.intakeDate)
        }
        
        // Gibt das Dictionary der gruppierten Mahlzeiten zurück
        return groupedMeals
    }
}






