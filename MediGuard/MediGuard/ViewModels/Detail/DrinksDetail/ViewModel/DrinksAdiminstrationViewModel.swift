//
//  DrinksAdiminstrationViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 01.07.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class DrinksAdiminstrationViewModel: ObservableObject {
    @Published var waterIntakes: [WaterIntake] = []
    @Published var errorMessage: String = ""
    
    private var listener: ListenerRegistration?
    
    init() {
        fetchWaterIntakes()
    }
    
    func fetchWaterIntakes() {
        listener?.remove()
        listener = Firestore.firestore().collection("waterIntakes")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der Wasseraufnahme: \(error.localizedDescription)"
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine Wasseraufnahmen gefunden"
                    return
                }
                self.waterIntakes = documents.compactMap { doc -> WaterIntake? in
                    try? doc.data(as: WaterIntake.self)
                }
            }
    }
    
    func addWaterIntake(count: Int) {
        let firestore = Firestore.firestore()
        let waterIntakeRef = firestore.collection("waterIntakes").document()
        let newWaterIntake = WaterIntake(id: waterIntakeRef.documentID, date: Date(), count: count)
        
        do {
            try waterIntakeRef.setData(from: newWaterIntake) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Hinzufügen der Wasseraufnahme: \(error.localizedDescription)"
                }
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der Wasseraufnahme: \(error.localizedDescription)"
        }
    }
    
    func updateWaterIntake(waterIntake: WaterIntake) {
        guard let id = waterIntake.id else { return }
        let waterIntakeRef = Firestore.firestore().collection("waterIntakes").document(id)
        
        do {
            try waterIntakeRef.setData(from: waterIntake) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Aktualisieren der Wasseraufnahme: \(error.localizedDescription)"
                }
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren der Wasseraufnahme: \(error.localizedDescription)"
        }
    }
}

