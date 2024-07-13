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

    var body: some View {
        Button(action: {
            // Schließt die aktuelle Ansicht
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .font(.system(size: 24, weight: .bold))
                Text("Zurück")
                    .foregroundColor(.blue)
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
}



