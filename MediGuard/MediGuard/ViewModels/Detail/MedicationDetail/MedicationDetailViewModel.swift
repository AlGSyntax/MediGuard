//
//  MedicationDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class MedicationViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    
    private var userViewModel: UserViewModel
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        fetchMedications()
    }
    
    func fetchMedications() {
        guard let userId = userViewModel.userId else { return }
        
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
    
    func addMedication(name: String, intakeTime: String, nextIntakeDate: String) {
        guard let userId = userViewModel.userId else { return }
        
        let newMedication = Medication(name: name, intakeTime: intakeTime, nextIntakeDate: nextIntakeDate)
        
        do {
            let _ = try Firestore.firestore().collection("users").document(userId).collection("medications").addDocument(from: newMedication)
            medications.append(newMedication)
        } catch let error {
            print("Error adding medication: \(error)")
        }
    }
}

