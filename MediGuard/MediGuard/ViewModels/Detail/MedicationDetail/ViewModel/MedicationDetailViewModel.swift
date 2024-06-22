//
//  MedicationDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - MedicationDetailViewModel Klasse

/**
 Die MedicationDetailViewModel-Klasse verwaltet die Daten und die Logik für die Detailansicht von Medikamenten.
 
 Diese Klasse ermöglicht das Abrufen, Hinzufügen, Aktualisieren und Löschen von Medikamenten sowie das Planen von Benachrichtigungen.
 */
@MainActor
class MedicationDetailViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    
    private var listener: ListenerRegistration?

    // MARK: - Methoden
    
    init() {
        listScheduledNotifications()
    }

    /**
     Fügt einen Listener hinzu, der die Medikamente für den angegebenen Benutzer aus der Firestore-Datenbank in Echtzeit abruft.
     
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func fetchMedications(userId: String) {
        listener?.remove() // Entfernt den alten Listener, falls vorhanden
        
        listener = Firestore.firestore().collection("users").document(userId).collection("medications")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching medications: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No medications found")
                    return
                }
                
                self.medications = documents.compactMap { doc -> Medication? in
                    try? doc.data(as: Medication.self)
                }
            }
    }
    
    /**
     Entfernt den Listener, um Änderungen zu stoppen.
     */
    func removeListener() {
        medications.removeAll()
        listener?.remove()
    }

    /**
     Plant eine Benachrichtigung für das angegebene Medikament.
     
     - Parameter medication: Das Medikament, für das die Benachrichtigung geplant werden soll.
     */
    func scheduleNotification(for medication: Medication) {
        let content = UNMutableNotificationContent()
        content.title = "Medikamentenerinnerung"
        content.body = "Es ist Zeit, \(medication.name) einzunehmen."
        content.sound = UNNotificationSound.default
        
        let date = Date().setTime(hour: medication.intakeTime.hour!, minute: medication.intakeTime.minute!)
        let comps = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            notifications.forEach { notification in
                guard let dateComponents = (notification.trigger as? UNCalendarNotificationTrigger)?.dateComponents,
                      let date = Calendar.current.date(from: dateComponents) else { return }
                print("-----> Notifications: ", date, notification.identifier)
            }
        }
    }

    /**
     Fügt ein neues Medikament hinzu und plant eine Benachrichtigung dafür.
     
     - Parameter name: Der Name des Medikaments.
     - Parameter intakeTime: Die Uhrzeit, zu der das Medikament eingenommen werden soll.
     - Parameter day: Der Wochentag, an dem das Medikament eingenommen werden soll.
     - Parameter nextIntakeDate: Das nächste geplante Einnahmedatum und -zeit (optional).
     - Parameter color: Die Farbe, die dem Medikament zugewiesen ist.
     - Parameter dosage: Die Dosierung des Medikaments.
     - Parameter dosageUnit: Die Einheit der Dosierung.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func addMedication(name: String, intakeTime: DateComponents, day: String, nextIntakeDate: DateComponents?, color: MedicationColor, dosage: Int, dosageUnit: DosageUnit, userId: String) {
        let firestore = Firestore.firestore()
        let medicationRef = firestore.collection("users").document(userId).collection("medications").document()

        // Den Snapshot-Listener für die neue Medikation setzen
        medicationRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }

            do {
                let medication = try document.data(as: Medication.self)
                self.medications.append(medication)
                self.scheduleNotification(for: medication)
            } catch let error {
                print("Error deserializing medication: \(error)")
            }
        }

        let newMedication = Medication(id: medicationRef.documentID, name: name, intakeTime: intakeTime, day: day, nextIntakeDate: nil, color: color, dosage: dosage, dosageUnit: dosageUnit)

        do {
            try medicationRef.setData(from: newMedication) // Daten in Firestore speichern
        } catch let error {
            print("Error adding medication: \(error)")
        }

        // Optionale Medikation speichern, falls vorhanden
        if let nextIntakeDate = nextIntakeDate {
            let nextMedicationRef = firestore.collection("users").document(userId).collection("medications").document()
            let nextDay = Weekday.from(nextIntakeDate.weekday)?.name ?? "Unbekannt"
            let nextMedication = Medication(id: nextMedicationRef.documentID, name: name, intakeTime: nextIntakeDate, day: nextDay, nextIntakeDate: nil, color: color, dosage: dosage, dosageUnit: dosageUnit)

            nextMedicationRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }

                do {
                    let medication = try document.data(as: Medication.self)
                    self.medications.append(medication)
                    self.scheduleNotification(for: medication)
                } catch let error {
                    print("Error deserializing medication: \(error)")
                }
            }

            do {
                try nextMedicationRef.setData(from: nextMedication) // Daten in Firestore speichern
            } catch let error {
                print("Error adding medication: \(error)")
            }
        }
    }

    /**
     Löscht ein Medikament und entfernt die zugehörige Benachrichtigung.
     
     - Parameter medication: Das zu löschende Medikament.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func deleteMedication(_ medication: Medication, userId: String) {
        guard let id = medication.id else { return }

        Firestore.firestore().collection("users").document(userId).collection("medications").document(id).delete { error in
            if let error {
                print("Error deleting medication: \(error)")
                return
            }

            self.medications.removeAll { $0.id == medication.id }
        }
        
        // Den Snapshot-Listener für die gelöschte Medikation aktualisieren
        fetchMedications(userId: userId)
    }

    /**
     Aktualisiert ein Medikament und plant eine neue Benachrichtigung.
     
     - Parameter medication: Das zu aktualisierende Medikament.
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func updateMedication(_ medication: Medication, userId: String) {
        guard let id = medication.id else {
            print("Medication ID is missing")
            return
        }

        let medicationRef = Firestore.firestore().collection("users").document(userId).collection("medications").document(id)
        
        // Den Snapshot-Listener für die aktualisierte Medikation setzen
        medicationRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }

            do {
                let updatedMedication = try document.data(as: Medication.self)
                if let index = self.medications.firstIndex(where: { $0.id == updatedMedication.id }) {
                    self.medications[index] = updatedMedication
                    self.scheduleNotification(for: updatedMedication)
                    print("Medication updated successfully")
                }
            } catch let error {
                print("Error deserializing medication: \(error)")
            }
        }

        do {
            try medicationRef.setData(from: medication) // Daten in Firestore speichern
        } catch let error {
            print("Error updating medication: \(error)")
        }
    }
}
