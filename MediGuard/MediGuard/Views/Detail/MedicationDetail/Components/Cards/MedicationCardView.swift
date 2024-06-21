//
//  MedicationCardView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

// MARK: - MedicationCardView

/**
 Die `MedicationCardView`-Struktur ist eine SwiftUI-View, die eine Karte zur Anzeige der Details eines Medikaments darstellt.
 
 Diese Karte zeigt den Namen des Medikaments, die Einnahmezeit, das nächste Einnahmedatum (falls vorhanden) und die Dosierung an. Zudem bietet sie Schaltflächen zum Bearbeiten und Löschen des Medikaments.
 
 - Eigenschaften:
    - `medication`: Das `Medication`-Objekt, das die anzuzeigenden Details des Medikaments enthält.
    - `onDelete`: Eine Funktion, die aufgerufen wird, wenn das Medikament gelöscht werden soll.
    - `onEdit`: Eine Funktion, die aufgerufen wird, wenn das Medikament bearbeitet werden soll.
 */
struct MedicationCardView: View {
    var medication: Medication
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    // MARK: - Hilfsfunktion

    /**
     Formatiert die `DateComponents` in eine lesbare Zeitdarstellung.
     
     - Parameter dateComponents: Die zu formatierenden `DateComponents`.
     - Returns: Eine formatierte Zeit als `String` oder "N/A", wenn die `DateComponents` ungültig sind.
     */
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

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Name des Medikaments
            Text(medication.name)
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Einnahmezeit
            Text("Einnahmezeit: \(formatDateComponents(medication.intakeTime))")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Nächstes Einnahmedatum (falls vorhanden)
            if let nextIntakeDate = medication.nextIntakeDate {
                Text("Nächstes Einnahmedatum: \(formatDateComponents(nextIntakeDate))")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            
            // Dosierung und Einheit
            HStack {
                Text("Dosierung: \(medication.dosage)")
                    .font(.title2)
                    .foregroundColor(.white)
                if medication.dosageUnit == .pills {
                    Image(systemName: "pills")
                        .foregroundColor(.white)
                } else {
                    Text(medication.dosageUnit.displayName)
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(medication.color.color) // Hintergrundfarbe basierend auf der Medikamentenfarbe
        .cornerRadius(20)
        .padding(.horizontal)
        .swipeActions(edge: .trailing) {
            // Löschen-Button
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Löschen", systemImage: "trash")
            }

            // Bearbeiten-Button
            Button {
                onEdit()
            } label: {
                Label("Bearbeiten", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }
}

// MARK: - Vorschau

struct MedicationCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedication = Medication(
            name: "Ibuprofen",
            intakeTime: DateComponents(hour: 14, minute: 30),
            day: "Montag",
            nextIntakeDate: DateComponents(hour: 14, minute: 30),
            color: .blue,
            dosage: 100,
            dosageUnit: .mg
        )
        MedicationCardView(medication: sampleMedication, onDelete: {}, onEdit: {})
    }
}







