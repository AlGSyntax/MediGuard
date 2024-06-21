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

    private func formatDateComponents(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = Calendar.current.date(from: dateComponents) {
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(meal.name)
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text("Einnahmezeit: \(formatDateComponents(meal.intakeTime))")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            if let nextIntakeDate = meal.nextIntakeDate {
                Text("Nächstes Mahlzeitdatum: \(formatDateComponents(nextIntakeDate))")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            
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
            name: "Frühstück",
            intakeTime: DateComponents(hour: 8, minute: 0),
            day: "Montag",
            nextIntakeDate: DateComponents(hour: 8, minute: 0),
            photoURL: nil,
            description: "Leckeres Frühstück"
        )
        MealCardView(meal: sampleMeal, onDelete: {}, onEdit: {})
    }
}

