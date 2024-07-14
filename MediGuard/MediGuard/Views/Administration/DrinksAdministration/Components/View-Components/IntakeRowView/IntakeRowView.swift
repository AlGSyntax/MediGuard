//
//  IntakeRowView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

/**
 Die `IntakeRowView`-Struktur ist eine benutzerdefinierte SwiftUI-View, die eine einzelne Zeile einer Flüssigkeitsaufnahme darstellt.
 
 Diese Ansicht zeigt die Menge, den Typ und die Uhrzeit der Aufnahme an und ermöglicht es dem Benutzer, auf ein Symbol zu tippen, um die ausgewählte Aufnahme zu verarbeiten.

 - Parameter:
    - intake: Ein `Intake`-Objekt, das die Details der Flüssigkeitsaufnahme enthält.
    - selectedIntake: Eine Closure, die ausgeführt wird, wenn auf das Herzsymbol getippt wird, um die Aufnahme auszuwählen.
 */
struct IntakeRowView: View {
    var intake: Intake
    var selectedIntake: (Intake) -> Void

    var body: some View {
        HStack {
            // Anzeige der Aufnahme-Menge in Millilitern
            Text("\(intake.amount) mL")
                .headlineBlue()
                

            Spacer()

            // Herzsymbol, das bei Tap die Aufnahme auswählt
            Image(systemName: "heart")
                .symbolVariant(.fill)
                .foregroundStyle(.red)
                .onTapGesture {
                    // Aktion beim Tippen auf das Herzsymbol
                    selectedIntake(intake)
                }

            // Anzeige des Typs der Aufnahme und ein Tropfensymbol
            HStack {
                // Typ der Aufnahme
                Text(intake.type)
                    .font(Fonts.callout)
                    .foregroundStyle(.blue)
                
                // Tropfensymbol, dessen Farbe vom Typ der Aufnahme abhängt
                Image(systemName: "drop")
                    .symbolVariant(.fill)
                    .foregroundStyle(IntakeTypeColor(rawValue: intake.type)?.color ?? .blue)
            }
            .frame(width: 80, alignment: .trailing)

            // Anzeige der Uhrzeit der Aufnahme
            Text(DateHelper.formatTime(date: intake.time))
                .bodyBlue()
                .frame(width: 80, alignment: .trailing)
        }
        .padding(.vertical, 10) // Vertikales Padding für die Zeile
    }
}

// MARK: - Preview

/**
 Vorschau der `IntakeRowView`-Struktur.
 
 Diese Vorschau ermöglicht es, die Ansicht in Xcode's SwiftUI Preview zu sehen.
 */
struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: Intake(amount: 250, type: "Wasser", time: Date())) { _ in }
    }
}




