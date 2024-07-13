//
//  MealCardView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI

/**
 Die Ansicht zur Darstellung einer einzelnen Mahlzeit.
 
 Diese Ansicht zeigt die Details einer Mahlzeit an, einschließlich des Namens, der Beschreibung und eines optionalen Fotos.
 Sie enthält Swipe-Aktionen zum Löschen der Mahlzeit.

 - Properties:
    - meal: Die darzustellende Mahlzeit.
    - onDelete: Eine Funktion, die ausgeführt wird, wenn die Mahlzeit gelöscht werden soll.
 */
struct MealCardView: View {
    /// Die darzustellende Mahlzeit.
    var meal: Meal
    
    /// Eine Funktion, die ausgeführt wird, wenn die Mahlzeit gelöscht werden soll.
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Name der Mahlzeit
            Text(meal.name)
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Optionales Foto der Mahlzeit
            if let photoURL = meal.photoURL, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
            
            // Beschreibung der Mahlzeit
            Text(meal.description)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color.blue)
        .cornerRadius(20)
        .padding(.horizontal)
        .swipeActions(edge: .trailing) {
            // Swipe-Aktion zum Löschen der Mahlzeit
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

// Vorschau der MealCardView
struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = Meal(
            id: UUID().uuidString,
            name: "Frühstück",
            intakeDate: Date(),
            photoURL: nil,
            description: "Leckeres Frühstück"
        )
        MealCardView(meal: sampleMeal, onDelete: {})
    }
}

