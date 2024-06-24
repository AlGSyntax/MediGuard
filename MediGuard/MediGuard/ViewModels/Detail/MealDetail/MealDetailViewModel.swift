//
//  MealDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

// MARK: - MealDetailViewModel

/**
 Die `MealDetailViewModel`-Klasse verwaltet die Daten und die Logik für die Detailansicht von Mahlzeiten.
 
 Diese Klasse ermöglicht das Abrufen, Hinzufügen, Aktualisieren und Löschen von Mahlzeiten sowie das Hochladen von Bildern.
 
 - Eigenschaften:
    - `meals`: Eine Liste von Mahlzeiten.
    - `errorMessage`: Eine Fehlermeldung, die angezeigt wird, wenn ein Fehler auftritt.
    - `selectedImage`: Ein ausgewähltes Bildobjekt vom Typ `PhotosPickerItem`.
    - `selectedImageData`: Die Daten des ausgewählten Bildes.
    - `listener`: Eine `ListenerRegistration`, um den Firestore-Listener zu entfernen.
 */
@MainActor
class MealDetailViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var errorMessage: String = ""
    @Published var selectedImage: PhotosPickerItem?
    @Published var selectedImageData: Data?

    private var listener: ListenerRegistration?
    
    
    // MARK: - Initializer
    
    init() {
        listScheduledNotifications()
    }
    
    
    // MARK: - Methods
    

    // MARK: - Fetch Meals

    /**
     Fügt einen Listener hinzu, der die Mahlzeiten für den angegebenen Benutzer aus der Firestore-Datenbank in Echtzeit abruft.
     
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func fetchMeals(userId: String) {
        listener?.remove()

        listener = Firestore.firestore().collection("users").document(userId).collection("meals")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Error fetching meals: \(error.localizedDescription)"
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "No meals found"
                    return
                }

                self.meals = documents.compactMap { doc -> Meal? in
                    try? doc.data(as: Meal.self)
                }
            }
    }
    
    
    /**
     Plant eine Benachrichtigung für das angegebene Medikament.
     
     - Parameter medication: Das Medikament, für das die Benachrichtigung geplant werden soll.
     */
    func scheduleNotification(for meal: Meal) {
        let content = UNMutableNotificationContent()
        content.title = "Mahlzeitennerinnerung"
        content.body = "Es ist Zeit, \(meal.name) essen."
        content.sound = UNNotificationSound.default
        
        let date = Date().setTime(hour: meal.intakeTime.hour!, minute: meal.intakeTime.minute!)
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.errorMessage = "Error scheduling notification: \(error.localizedDescription)"
            }
        }
    }
    
    /**
     Listet alle geplanten Benachrichtigungen auf.
     */
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            notifications.forEach { notification in
                guard let dateComponents = (notification.trigger as? UNCalendarNotificationTrigger)?.dateComponents,
                      let date = Calendar.current.date(from: dateComponents) else { return }
                print("-----> Notifications: ", date, notification.identifier)
            }
        }
    }

    

    // MARK: - Add Meal

    /**
     Fügt eine neue Mahlzeit hinzu und überwacht deren Status in der Firestore-Datenbank.
     
     - Parameter name: Der Name der Mahlzeit.
     - Parameter intakeTime: Die Uhrzeit der Einnahme der Mahlzeit.
     - Parameter day: Der Wochentag der Einnahme der Mahlzeit.
     - Parameter nextIntakeDate: Das nächste geplante Einnahmedatum und -zeit (optional).
     - Parameter photoURL: Die URL des Fotos der Mahlzeit (optional).
     - Parameter description: Die Beschreibung der Mahlzeit.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func addMeal(name: String, intakeTime: DateComponents, day: Weekday, nextIntakeDate: DateComponents?, photoURL: String?, description: String, userId: String) {
        let firestore = Firestore.firestore()
        let mealRef = firestore.collection("users").document(userId).collection("meals").document()
        let newMeal = Meal(id: mealRef.documentID, name: name, intakeTime: intakeTime, day: day.name, nextIntakeDate: nil, photoURL: photoURL, description: description)

        mealRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                self.errorMessage = "Error fetching document: \(error!.localizedDescription)"
                return
            }
            guard document.exists else {
                self.errorMessage = "Document does not exist."
                return
            }

            do {
                let meal = try document.data(as: Meal.self)
                self.meals.append(meal)
                self.scheduleNotification(for: meal)
            } catch let error {
                self.errorMessage = "Error deserializing meal: \(error.localizedDescription)"
            }
        }

        if let nextIntakeDate = nextIntakeDate {
            let nextMealRef = firestore.collection("users").document(userId).collection("meals").document()
            let nextDay = Weekday.from(nextIntakeDate.weekday ?? 1)?.name ?? "Unbekannt"
            let nextMeal = Meal(id: nextMealRef.documentID, name: name, intakeTime: nextIntakeDate, day: nextDay, nextIntakeDate: nil, photoURL: photoURL, description: description)

            nextMealRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    self.errorMessage = "Error fetching document: \(error!.localizedDescription)"
                    return
                }
                guard document.exists else {
                    self.errorMessage = "Document does not exist."
                    return
                }

                do {
                    let meal = try document.data(as: Meal.self)
                    self.meals.append(meal)
                    self.scheduleNotification(for: meal)
                } catch let error {
                    self.errorMessage = "Error deserializing meal: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Delete Meal

    /**
     Löscht eine Mahlzeit und überwacht deren Status in der Firestore-Datenbank.
     
     - Parameter meal: Die zu löschende Mahlzeit.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func deleteMeal(_ meal: Meal, userId: String) {
        guard let id = meal.id else { return }

        let mealRef = Firestore.firestore().collection("users").document(userId).collection("meals").document(id)

        mealRef.delete { error in
            if let error = error {
                self.errorMessage = "Error deleting meal: \(error.localizedDescription)"
                return
            }

            mealRef.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    self.errorMessage = "Error fetching meal: \(error.localizedDescription)"
                    return
                }
                guard let document = documentSnapshot else {
                    self.errorMessage = "Meal document does not exist."
                    return
                }
                if !document.exists {
                    self.meals.removeAll { $0.id == meal.id }
                }
            }
        }
    }

    // MARK: - Update Meal

    /**
     Aktualisiert eine Mahlzeit und überwacht deren Status in der Firestore-Datenbank.
     
     - Parameter meal: Die zu aktualisierende Mahlzeit.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func updateMeal(_ meal: Meal, userId: String) {
        guard let id = meal.id else {
            self.errorMessage = "Meal ID is missing"
            return
        }

        let mealRef = Firestore.firestore().collection("users").document(userId).collection("meals").document(id)

        mealRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                self.errorMessage = "Error fetching document: \(error!.localizedDescription)"
                return
            }
            guard document.exists else {
                self.errorMessage = "Document does not exist."
                return
            }

            do {
                let updatedMeal = try document.data(as: Meal.self)
                if let index = self.meals.firstIndex(where: { $0.id == updatedMeal.id }) {
                    self.meals[index] = updatedMeal
                    print("Meal updated successfully")
                }
            } catch let error {
                self.errorMessage = "Error deserializing meal: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Upload Image

    /**
     Bild zu Firebase Storage hochladen.
     
     Speichern des Bildes innerhalb eines Ordners mit der jeweiligen userId und als Name der Datei wird die ID der Mahlzeit genutzt.
     Dadurch wird beim Aktualisieren des Bildes die alte Datei direkt ersetzt.
     
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     - Parameter mealId: Die eindeutige Kennung der Mahlzeit.
     - Parameter completion: Ein Abschluss-Handler, der die URL des hochgeladenen Bildes zurückgibt.
     */
    func uploadImage(userId: String, mealId: String, completion: @escaping (String?) -> Void) {
        guard let selectedImageData else { return }

        // Referenz erstellen zum Speicherort des Bildes
        let reference = Storage.storage().reference().child("mealPhotos/\(userId)/\(mealId).jpg")

        reference.putData(selectedImageData, metadata: nil) { _, error in
            if let error = error {
                self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                completion(nil)
                return
            }

            self.getImageURL(from: reference, completion: completion)
        }
    }

    /**
     Abfragen der URL, wo das Bild im Storage liegt.
     
     Die URL wird beim jeweiligen Mahlzeit in Firestore gespeichert, sodass diese abgefragt werden kann.
     
     - Parameter reference: Die `StorageReference` des Bildes.
     - Parameter completion: Ein Abschluss-Handler, der die URL des Bildes zurückgibt.
     */
    private func getImageURL(from reference: StorageReference, completion: @escaping (String?) -> Void) {
        reference.downloadURL { url, error in
            if let error = error {
                self.errorMessage = "Error getting download URL: \(error.localizedDescription)"
                completion(nil)
                return
            }

            guard let url else {
                self.errorMessage = "URL does not exist."
                completion(nil)
                return
            }

            completion(url.absoluteString)
        }
    }
}



