//
//  CostumBackButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

/**
 Ein benutzerdefinierter Zurück-Button, der die aktuelle Ansicht schließt und zur vorherigen Ansicht navigiert.
 
 Dieser Button verwendet die `presentationMode`-Umgebungsvariable, um die aktuelle Ansicht zu schließen. Er zeigt ein Symbol und Text an, die den Benutzer zurück zur vorherigen Ansicht führen.

 - Properties:
    - presentationMode: Eine Umgebungsvariable, die den Präsentationsmodus der aktuellen Ansicht enthält.
 */
struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isTapped = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isTapped = true // Startet die Animation beim Tap
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isTapped = false // Rücksetzung der Animation nach kurzer Verzögerung
                }
                self.presentationMode.wrappedValue.dismiss() // Schließt die aktuelle Ansicht
            }
        }) {
            HStack {
                Image(systemName: "arrowshape.backward.circle.fill")
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.blue)
                    .font(.system(size: 34, weight: .bold))
                    .scaleEffect(isTapped ? 1.1 : 1.0) // Vergrößert die Ansicht beim Tap
                    .opacity(isTapped ? 0.8 : 1.0) // Verringert die Deckkraft beim Tap
            }
        }
    }
}

// MARK: - Vorschau

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}




