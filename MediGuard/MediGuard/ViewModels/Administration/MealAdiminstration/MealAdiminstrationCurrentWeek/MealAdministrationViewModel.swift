//
//  MealDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
// MealDetailViewModel.swift
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

/**
 Das ViewModel zur Verwaltung der Mahlzeiten.
 
 Dieses ViewModel kümmert sich um das Abrufen, Hinzufügen, Aktualisieren und Löschen von Mahlzeiten sowie um das Hochladen von Bildern. 
 Es enthält auch Hilfsfunktionen zur Handhabung von Datumsoperationen.

 - Eigenschaften:
    - meals: Eine Liste von Mahlzeiten.
    - errorMessage: Eine Fehlermeldung, falls ein Fehler auftritt.
    - selectedImageData: Die Daten des ausgewählten Bildes.
    - showAlert: Ein Zustand zur Steuerung der Anzeige von Alerts.
    - alertMessage: Die Nachricht, die im Alert angezeigt wird.
 */
@MainActor
class MealAdministrationViewModel: ObservableObject {
    // MARK: - Eigenschaften
    
    /// Eine Liste von Mahlzeiten.
    @Published var meals: [Meal] = []
    
    /// Eine Fehlermeldung, falls ein Fehler auftritt.
    @Published var errorMessage: String = ""
    
    /// Die Daten des ausgewählten Bildes.
    @Published var selectedImageData: Data?
    
    /// Ein Zustand zur Steuerung der Anzeige von Alerts.
    @Published var showAlert = false
    
    /// Die Nachricht, die im Alert angezeigt wird.
    @Published var alertMessage = ""
    
    /// Der Listener für Änderungen in der Firestore-Datenbank.
    private var listener: ListenerRegistration?
    
    // MARK: - Methoden
    
    /**
     Ruft die Mahlzeiten eines bestimmten Benutzers ab.
     
     - Parameter userId: Die Benutzer-ID, für die die Mahlzeiten abgerufen werden sollen.
     */
    func fetchMeals(userId: String) {
        listener?.remove()
        listener = Firestore.firestore().collection("users").document(userId).collection("meals")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der Mahlzeiten: \(error.localizedDescription)"
                    print(self.errorMessage) // Debugging-Ausgabe
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine Mahlzeiten gefunden"
                    print(self.errorMessage) // Debugging-Ausgabe
                    return
                }
                self.meals = documents.compactMap { doc -> Meal? in
                    try? doc.data(as: Meal.self)
                }.filter { meal in
                    Calendar.current.isDate(meal.intakeDate, equalTo: Date(), toGranularity: .weekOfYear)
                }
                print("Fetched meals: \(self.meals)") // Debugging-Ausgabe
            }
    }
    
    /**
     Validiert die Eingaben und fügt eine neue Mahlzeit hinzu.
     
     - Parameter userId: Die Benutzer-ID.
     - Parameter mealName: Der Name der Mahlzeit.
     - Parameter description: Die Beschreibung der Mahlzeit.
     - Parameter selectedDate: Das ausgewählte Datum der Mahlzeit.
     - Parameter selectedTime: Die ausgewählte Uhrzeit der Mahlzeit.
     - Parameter photo: Das Foto der Mahlzeit.
     */
    func validateAndAddMeal(userId: String?, mealName: String, description: String, selectedDate: Date, selectedTime: Date, photo: UIImage?) {
        guard let userId = userId else {
            alertMessage = "Benutzer-ID fehlt."
            showAlert = true
            return
        }

        guard !mealName.isEmpty, !description.isEmpty else {
            alertMessage = "Bitte füllen Sie alle Felder aus."
            showAlert = true
            return
        }

        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute

        guard let finalIntakeTime = Calendar.current.date(from: components) else {
            alertMessage = "Fehler bei der Erstellung des Datums."
            showAlert = true
            return
        }

        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
            selectedImageData = imageData
            uploadImage(mealId: UUID().uuidString) { url in
                if let url = url {
                    self.addMeal(userId: userId, name: mealName, intakeTime: finalIntakeTime, photoURL: url, description: description)
                }
            }
        } else {
            addMeal(userId: userId, name: mealName, intakeTime: finalIntakeTime, photoURL: nil, description: description)
        }
    }

    /**
     Fügt eine neue Mahlzeit zur Datenbank hinzu.
     
     - Parameter userId: Die Benutzer-ID.
     - Parameter name: Der Name der Mahlzeit.
     - Parameter intakeTime: Das Datum und die Uhrzeit der Mahlzeit.
     - Parameter photoURL: Die URL des Fotos der Mahlzeit.
     - Parameter description: Die Beschreibung der Mahlzeit.
     */
    func addMeal(userId: String, name: String, intakeTime: Date, photoURL: String?, description: String) {
        let firestore = Firestore.firestore()
        let mealRef = firestore.collection("users").document(userId).collection("meals").document()
        let newMeal = Meal(id: mealRef.documentID, name: name, intakeDate: intakeTime, photoURL: photoURL, description: description)

        do {
            try mealRef.setData(from: newMeal) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Hinzufügen der Mahlzeit: \(error.localizedDescription)"
                    return
                }
                self.fetchMeals(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der Mahlzeit: \(error.localizedDescription)"
        }
    }

    /**
     Aktualisiert eine bestehende Mahlzeit in der Datenbank.
     
     - Parameter userId: Die Benutzer-ID.
     - Parameter meal: Die zu aktualisierende Mahlzeit.
     */
    func updateMeal(userId: String, meal: Meal) {
        guard let id = meal.id else { return }
        let mealRef = Firestore.firestore().collection("users").document(userId).collection("meals").document(id)

        do {
            try mealRef.setData(from: meal) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Aktualisieren der Mahlzeit: \(error.localizedDescription)"
                    return
                }
                self.fetchMeals(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der Mahlzeit: \(error.localizedDescription)"
        }
    }

    /**
     Löscht eine Mahlzeit aus der Datenbank.
     
     - Parameter meal: Die zu löschende Mahlzeit.
     - Parameter userId: Die Benutzer-ID.
     */
    func deleteMeal(_ meal: Meal, userId: String) {
        guard let id = meal.id else { return }
        let mealRef = Firestore.firestore().collection("users").document(userId).collection("meals").document(id)

        mealRef.delete { error in
            if let error = error {
                self.errorMessage = "Fehler beim Löschen der Mahlzeit: \(error.localizedDescription)"
                return
            }
            self.fetchMeals(userId: userId)
        }
    }

    /**
     Lädt ein Bild in Firebase Storage hoch und ruft die URL ab.
     
     - Parameter mealId: Die ID der Mahlzeit.
     - Parameter completion: Ein Abschluss-Handler, der die URL des hochgeladenen Bildes zurückgibt.
     */
    func uploadImage(mealId: String, completion: @escaping (String?) -> Void) {
        guard let selectedImageData = selectedImageData else { return }
        let reference = Storage.storage().reference().child("mealPhotos/\(mealId).jpg")

        reference.putData(selectedImageData, metadata: nil) { _, error in
            if let error = error {
                self.errorMessage = "Fehler beim Hochladen des Bildes: \(error.localizedDescription)"
                completion(nil)
                return
            }
            self.getImageURL(from: reference, completion: completion)
        }
    }

    /**
     Ruft die Download-URL eines Bildes aus Firebase Storage ab.
     
     - Parameter reference: Der Storage-Referenzpfad des Bildes.
     - Parameter completion: Ein Abschluss-Handler, der die URL des Bildes zurückgibt.
     */
    private func getImageURL(from reference: StorageReference, completion: @escaping (String?) -> Void) {
        reference.downloadURL { url, error in
            if let error = error {
                self.errorMessage = "Fehler beim Abrufen der Download-URL: \(error.localizedDescription)"
                completion(nil)
                return
            }
            guard let url = url else {
                self.errorMessage = "URL existiert nicht."
                completion(nil)
                return
            }
            completion(url.absoluteString)
        }
    }

    // MARK: - Hilfsfunktionen
    
    /**
     Gibt die aktuelle Wochennummer des Jahres zurück.
     
     - Returns: Die aktuelle Wochennummer.
     */
    func currentWeekNumber() -> Int {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        return weekOfYear
    }

    /**
     Gibt alle Tage der aktuellen Woche zurück.
     
     - Returns: Ein Array mit den Daten der aktuellen Woche.
     */
    func currentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var week: [Date] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            let startOfWeek = weekInterval.start
            for day in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: day, to: startOfWeek), date >= today {
                    week.append(date)
                }
            }
        }
        return week
    }

    /**
     Überprüft, ob ein Datum in der aktuellen Woche liegt.
     
     - Parameter date: Das zu überprüfende Datum.
     - Returns: `true` wenn das Datum in der aktuellen Woche liegt, ansonsten `false`.
     */
    func isInCurrentWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return false
        }
        return weekInterval.contains(date)
    }

    /**
     Überprüft, ob ein Datum in der Vergangenheit liegt.
     
     - Parameter date: Das zu überprüfende Datum.
     - Returns: `true` wenn das Datum in der Vergangenheit liegt, ansonsten `false`.
     */
    func isInPast(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return date < calendar.startOfDay(for: Date())
    }
}
