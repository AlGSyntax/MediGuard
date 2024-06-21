//
//  MealDetailViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class MealDetailViewModel: ObservableObject {
    @Published var meals: [Meal] = []

    func fetchMeals(userId: String) {
        Firestore.firestore().collection("users").document(userId).collection("meals").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching meals: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No meals found")
                return
            }

            self.meals = documents.compactMap { doc -> Meal? in
                try? doc.data(as: Meal.self)
            }
        }
    }

    func addMeal(name: String, intakeTime: DateComponents, day: String, nextIntakeDate: DateComponents?, photoURL: String?, description: String, userId: String) {
        var mealsToAdd = [Meal]()
        
        let newMealID = UUID().uuidString
        let newMeal = Meal(id: newMealID, name: name, intakeTime: intakeTime, day: day, nextIntakeDate: nil, photoURL: photoURL, description: description)
        mealsToAdd.append(newMeal)
        
        if let nextIntakeDate = nextIntakeDate {
            let nextMealID = UUID().uuidString
            let nextMeal = Meal(id: nextMealID, name: name, intakeTime: nextIntakeDate, day: getDayString(from: nextIntakeDate.weekday), nextIntakeDate: nil, photoURL: photoURL, description: description)
            mealsToAdd.append(nextMeal)
        }

        do {
            for meal in mealsToAdd {
                let _ = try Firestore.firestore().collection("users").document(userId).collection("meals").document(meal.id!).setData(from: meal)
                meals.append(meal)
            }
        } catch let error {
            print("Error adding meal: \(error)")
        }
    }

    func deleteMeal(_ meal: Meal, userId: String) {
        guard let id = meal.id else { return }

        Firestore.firestore().collection("users").document(userId).collection("meals").document(id).delete { error in
            if let error = error {
                print("Error deleting meal: \(error)")
                return
            }

            self.meals.removeAll { $0.id == meal.id }
        }
    }

    func updateMeal(_ meal: Meal, userId: String) {
        guard let id = meal.id else {
            print("Meal ID is missing")
            return
        }

        do {
            try Firestore.firestore().collection("users").document(userId).collection("meals").document(id).setData(from: meal)
            if let index = self.meals.firstIndex(where: { $0.id == meal.id }) {
                self.meals[index] = meal
                print("Meal updated successfully")
            }
        } catch let error {
            print("Error updating meal: \(error)")
        }
    }

    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("mealPhotos/\(UUID().uuidString).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                    completion(nil)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                            completion(nil)
                        } else {
                            completion(url?.absoluteString)
                        }
                    }
                }
            }
        } else {
            completion(nil)
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

