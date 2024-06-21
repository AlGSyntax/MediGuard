//
//  MedicationDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class MedicationDetailViewModel: ObservableObject {
    @Published var medications: [Medication] = []

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
                    let nextMedication = Medication(id: nextMedicationID, name: name, intakeTime: nextIntakeDate, day: getDayString(from: nextIntakeDate.weekday), nextIntakeDate: nil, color: color, dosage: dosage, dosageUnit: dosageUnit)
                    let _ = try Firestore.firestore().collection("users").document(userId).collection("medications").document(nextMedicationID).setData(from: nextMedication)
                    medications.append(nextMedication)
                    scheduleNotification(for: nextMedication)
                }
            } catch let error {
                print("Error adding medication: \(error)")
            }
        }

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
    private func getDayString(from weekday: Int?) -> String {
           switch weekday {
           case 2: return "Montag"
           case 3: return "Dienstag"
           case 4: return "Mittwoch"
           case 5: return "Donnerstag"
           case 6: return "Freitag"
           case 7: return "Samstag"
           case 1: return "Sonntag"
           default: return "Unbekannt"
           }
       }
}

