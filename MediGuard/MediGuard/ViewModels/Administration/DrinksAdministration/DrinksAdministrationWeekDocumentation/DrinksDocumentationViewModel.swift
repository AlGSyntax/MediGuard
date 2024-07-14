//
//  DrinksDocumentationViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.07.24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

/**
 Das `DrinksDocumentationViewModel` verwaltet die Logik für das Abrufen und Verarbeiten der Getränkedaten des Benutzers.
 Es enthält Methoden zum Abrufen der aktuellen Woche und der vergangenen Wochen, zum Gruppieren von Getränken nach Tagen und Wochen und zum Speichern von vergangenen Wochen.
 
 - Properties:
    - pastWeeks: Ein Array von `Week`-Objekten, das die vergangenen Wochen des Benutzers enthält.
    - currentWeek: Ein optionales `Week`-Objekt, das die aktuelle Woche des Benutzers enthält.
    - errorMessage: Eine Zeichenkette, die Fehlermeldungen speichert.
    - goal: Ein Zielwert in Millilitern für die tägliche Flüssigkeitsaufnahme.
 */
@MainActor
class DrinksDocumentationViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var pastWeeks: [Week] = []
    @Published var currentWeek: Week?
    @Published var errorMessage: String = ""
    let goal: Int = 3000  // Beispielziel in Millilitern

    // MARK: - Fetch Methods
    
    /**
         Ruft die vergangenen Wochen des Benutzers aus Firestore ab.
         
         - Parameter userId: Die Benutzer-ID, für die die vergangenen Wochen abgerufen werden sollen.
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
                self.pastWeeks = documents.compactMap { doc -> Week? in
                    try? doc.data(as: Week.self)
                }
            }
    }
    
    /**
         Ruft die Getränke der aktuellen Woche des Benutzers aus Firestore ab.
         
         - Parameter userId: Die Benutzer-ID, für die die Getränke der aktuellen Woche abgerufen werden sollen.
         */
    func fetchCurrentWeek(userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("intakes")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der Getränke: \(error.localizedDescription)"
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine Getränke gefunden"
                    return
                }
                let allIntakes = documents.compactMap { doc -> Intake? in
                    try? doc.data(as: Intake.self)
                }
                self.processIntakes(allIntakes, userId: userId)
            }
    }

    // MARK: - Processing Methods
    
    /**
         Verarbeitet die abgerufenen Getränke, um sie in aktuelle und vergangene Wochen zu unterteilen.
         
         - Parameters:
            - intakes: Ein Array von `Intake`-Objekten, das die abgerufenen Getränke enthält.
            - userId: Die Benutzer-ID, für die die Getränke verarbeitet werden sollen.
         */
    private func processIntakes(_ intakes: [Intake], userId: String) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var currentWeekIntakes: [Intake] = []
        var pastWeekIntakes: [Intake] = []

        for intake in intakes {
            if calendar.isDate(intake.time, equalTo: today, toGranularity: .weekOfYear) {
                currentWeekIntakes.append(intake)
            } else {
                pastWeekIntakes.append(intake)
            }
        }

        if !pastWeekIntakes.isEmpty {
            let pastWeek = groupIntakesByWeek(pastWeekIntakes).first
            if let pastWeek = pastWeek {
                self.checkAndSavePastWeek(userId: userId, pastWeek: pastWeek)
            }
        }

        let weekNumber = calendar.component(.weekOfYear, from: today)
        self.currentWeek = Week(weekNumber: weekNumber, intakes: currentWeekIntakes)
    }
    
    
    /**
       Überprüft, ob die vergangene Woche bereits gespeichert wurde, und speichert sie bei Bedarf.
       
       - Parameters:
          - userId: Die Benutzer-ID, für die die vergangene Woche überprüft und gespeichert werden soll.
          - pastWeek: Ein `Week`-Objekt, das die vergangene Woche enthält.
       */
    private func checkAndSavePastWeek(userId: String, pastWeek:Week) {
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
         Speichert die vergangene Woche in Firestore.
         
         - Parameters:
            - userId: Die Benutzer-ID, für die die vergangene Woche gespeichert werden soll.
            - pastWeek: Ein `Week`-Objekt, das die vergangene Woche enthält.
         */
    func savePastWeek(userId: String, pastWeek: Week) {
        let pastWeekRef = Firestore.firestore().collection("users").document(userId).collection("pastWeeks").document(pastWeek.id ?? UUID().uuidString)
        
        do {
            try pastWeekRef.setData(from: pastWeek) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Speichern der vergangenen Woche: \(error.localizedDescription)"
                    return
                }
                self.fetchPastWeeks(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der vergangenen Woche: \(error.localizedDescription)"
        }
    }

    // MARK: - Grouping Methods
    
    /**
         Gruppiert die Getränke nach Wochen.
         
         - Parameter intakes: Ein Array von `Intake`-Objekten, das die Getränke enthält.
         - Returns: Ein Array von `Week`-Objekten, das die Getränke nach Wochen gruppiert enthält.
         */
    private func groupIntakesByWeek(_ intakes: [Intake]) -> [Week] {
        let calendar = Calendar.current
        let groupedIntakes = Dictionary(grouping: intakes) { intake -> Int in
            let weekOfYear = calendar.component(.weekOfYear, from: intake.time)
            return weekOfYear
        }

        return groupedIntakes.map { (weekNumber, intakes) in
            Week(weekNumber: weekNumber, intakes: intakes)
        }
    }
    
    /**
        Gruppiert die Getränke nach Tagen.
        
        - Parameter intakes: Ein Array von `Intake`-Objekten, das die Getränke enthält.
        - Returns: Ein Dictionary, das die Getränke nach Tagen gruppiert enthält.
        */
    func groupIntakesByDay(_ intakes: [Intake]) -> [String: [Intake]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let groupedIntakes = Dictionary(grouping: intakes) { intake -> String in
            formatter.string(from: intake.time)
        }
        return groupedIntakes
    }
}


