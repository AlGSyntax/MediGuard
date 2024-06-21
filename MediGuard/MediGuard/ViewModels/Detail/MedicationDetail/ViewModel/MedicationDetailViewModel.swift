//
//  MedicationDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI
import FirebaseFirestore

// MARK: - MedicationDetailViewModel Klasse

/**
 Die `MedicationDetailViewModel`-Klasse verwaltet die Daten und die Logik für die Detailansicht von Medikamenten.
 
 Diese Klasse ermöglicht das Abrufen, Hinzufügen, Aktualisieren und Löschen von Medikamenten sowie das Planen von Benachrichtigungen.
 */
@MainActor
class MedicationDetailViewModel: ObservableObject {
    @Published var medications: [Medication] = []

    // MARK: - Methoden

    /**
     Ruft die Medikamente für den angegebenen Benutzer aus der Firestore-Datenbank ab.
     
     - Parameter userId: Die eindeutige Kennung des Benutzers.
     */
    func fetchMedications(userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("medications").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching medications: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No medications found")
                return
            }

            self.medications = documents.compactMap { doc -> Medication? in
                try? doc.data(as: Medication.self)
            }
        }
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
        
        let dateComponents = medication.intakeTime
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
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
        let newMedicationID = UUID().uuidString
        let newMedication = Medication(id: newMedicationID, name: name, intakeTime: intakeTime, day: day, nextIntakeDate: nil, color: color, dosage: dosage, dosageUnit: dosageUnit)
        
        do {
            // Hauptmedikation speichern
            let _ = try Firestore.firestore().collection("users").document(userId).collection("medications").document(newMedicationID).setData(from: newMedication)
            medications.append(newMedication)
            scheduleNotification(for: newMedication)
            
            // Optionale Medikation speichern, falls vorhanden
            if let nextIntakeDate = nextIntakeDate {
                let nextMedicationID = UUID().uuidString
                let nextDay = Weekday.from(nextIntakeDate.weekday)?.name ?? "Unbekannt"
                let nextMedication = Medication(id: nextMedicationID, name: name, intakeTime: nextIntakeDate, day: nextDay, nextIntakeDate: nil, color: color, dosage: dosage, dosageUnit: dosageUnit)
                let _ = try Firestore.firestore().collection("users").document(userId).collection("medications").document(nextMedicationID).setData(from: nextMedication)
                medications.append(nextMedication)
                scheduleNotification(for: nextMedication)
            }
        } catch let error {
            print("Error adding medication: \(error)")
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
            if let error = error {
                print("Error deleting medication: \(error)")
                return
            }

            self.medications.removeAll { $0.id == medication.id }
        }
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

        do {
            try Firestore.firestore().collection("users").document(userId).collection("medications").document(id).setData(from: medication)
            if let index = self.medications.firstIndex(where: { $0.id == medication.id }) {
                self.medications[index] = medication
                scheduleNotification(for: medication)
                print("Medication updated successfully")
            }
        } catch let error {
            print("Error updating medication: \(error)")
        }
    }
}


