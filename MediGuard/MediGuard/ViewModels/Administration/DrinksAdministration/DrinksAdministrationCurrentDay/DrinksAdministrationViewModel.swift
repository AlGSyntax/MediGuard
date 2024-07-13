//
//  DrinksAdiminstrationViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 01.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

@MainActor
class DrinksAdministrationViewModel: ObservableObject {
    @Published var intakes: [Intake] = []
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var progress: Float = 0.0
    @Published var intakesAmount: Int = 0

    private var listener: ListenerRegistration?
    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000

    func fetchIntakes(userId: String) {
        listener?.remove()
        let startOfDay = Calendar.current.startOfDay(for: Date())

        listener = Firestore.firestore().collection("users").document(userId).collection("intakes")
            .whereField("time", isGreaterThanOrEqualTo: startOfDay)
            .order(by: "time", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fehler beim Abrufen der Getränke: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "Keine Getränke gefunden"
                    return
                }
                
                self.intakes = documents.compactMap { doc -> Intake? in
                    try? doc.data(as: Intake.self)
                }
                self.updateProgress()
            }
    }

    func addIntake(amount: Int, type: String, time: Date,  userId: String) {
        let firestore = Firestore.firestore()
        let intakeRef = firestore.collection("users").document(userId).collection("intakes")
        
        let newIntake = Intake(amount: amount, type: type, time: time)
        
        do {
            try intakeRef.addDocument(from: newIntake) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Hinzufügen des Getränks: \(error.localizedDescription)"
                    return
                }
                self.fetchIntakes(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren des Getränks: \(error.localizedDescription)"
        }
    }

    func deleteIntake(at offsets: IndexSet) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        for index in offsets {
            let intake = intakes[index]
            guard let id = intake.id else { continue }
            let intakeRef = Firestore.firestore().collection("users").document(userId).collection("intakes").document(id)

            intakeRef.delete { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Löschen des Getränks: \(error.localizedDescription)"
                    return
                }
                self.intakes.remove(at: index)
                self.updateProgress()
            }
        }
    }

    func updateIntake(_ intake: Intake, userId: String) {
        guard let id = intake.id else {
            self.errorMessage = "Medikations-ID fehlt"
            return
        }
        
        let intakeRef = Firestore.firestore().collection("users").document(userId).collection("intakes").document(id)

        do {
            try intakeRef.setData(from: intake) { error in
                if let error = error {
                    self.errorMessage = "Fehler beim Aktualisieren des Getränks: \(error.localizedDescription)"
                }
                self.fetchIntakes(userId: userId)
            }
        } catch let error {
            self.errorMessage = "Fehler beim Serialisieren des Getränks: \(error.localizedDescription)"
        }
    }

    func logIntake(_ intake: Intake, userId: String) {
        updateIntake(intake, userId: userId)
    }

    @MainActor
    func setAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
    
    private func updateProgress() {
        intakesAmount = intakes.reduce(0) { $0 + $1.amount }
        progress = Float(intakesAmount) / Float(goal)
    }
}



