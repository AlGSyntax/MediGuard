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
    var showNextIntakeDate: Bool = true
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    // MARK: - Hilfsfunktion

    /**
     Formatiert die `DateComponents` in eine lesbare Zeitdarstellung.
     
     - Parameter dateComponents: Die zu formatierenden `DateComponents`.
     - Returns: Eine formatierte Zeit als `String` oder "N/A", wenn die `DateComponents` ungültig sind.
     */
    private func formatTime(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents else { return "N/A" }
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        return String(format: "%02d:%02d", hour, minute)
    }

    /**
     Formatiert die `DateComponents` in eine lesbare Darstellung von Wochentag und Uhrzeit.
     
     - Parameter dateComponents: Die zu formatierenden `DateComponents`.
     - Returns: Eine formatierte Darstellung von Wochentag und Uhrzeit als `String` oder "N/A", wenn die `DateComponents` ungültig sind.
     */
    private func formatWeekdayAndTime(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents else { return "N/A" }
        let weekday = Weekday.from(dateComponents.weekday ?? 1)?.name ?? "N/A"
        let time = formatTime(dateComponents)
        return "\(weekday), \(time)"
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
            Text("Einnahmezeit: \(formatTime(medication.intakeTime))")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            // Nächstes Einnahmedatum (falls vorhanden und wenn angezeigt werden soll)
            if showNextIntakeDate, let nextIntakeDate = medication.nextIntakeDate {
                Text("Nächstes Einnahmedatum: \(formatWeekdayAndTime(nextIntakeDate))")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(medication.color.color) // Hintergrundfarbe basierend auf der Medikamentenfarbe
        .cornerRadius(20)
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
            nextIntakeDate: DateComponents(hour: 14, minute: 30, weekday: 3),
            color: .blue,
            dosage: 100,
            dosageUnit: .mg
        )
        MedicationCardView(medication: sampleMedication, onDelete: {}, onEdit: {})
    }
}










