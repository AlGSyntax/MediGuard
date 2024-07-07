//
//  MealCardView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI

struct MealCardView: View {
    var meal: Meal
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(meal.name)
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            if let photoURL = meal.photoURL, let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
            
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
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Löschen", systemImage: "trash")
            }

            Button {
                onEdit()
            } label: {
                Label("Bearbeiten", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }
}

struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = Meal(
            id: UUID().uuidString,
            name: "Frühstück",
            intakeDate: Date(),
            photoURL: nil,
            description: "Leckeres Frühstück"
        )
        MealCardView(meal: sampleMeal, onDelete: {}, onEdit: {})
    }
}
