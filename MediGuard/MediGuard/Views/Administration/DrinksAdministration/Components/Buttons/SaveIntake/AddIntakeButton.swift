//
//  AddIntakeButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - AddIntakeButton

/**
 Ein benutzerdefinierter Button, der einen Text und ein Symbol anzeigt und eine Aktion ausführt, wenn er gedrückt wird.

 Der `AddIntakeButton` zeigt ein Symbol und einen Text an und führt die angegebene Aktion aus, wenn er gedrückt wird.
 
 - Properties:
    - action: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct AddIntakeButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.blue) // Setzt die Farbe des Hintergrunds auf Blau

                HStack {
                    Text("Speichern")
                        .foregroundStyle(.white) // Setzt die Schriftfarbe auf Weiß
                    
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(.white) // Setzt die Symbolfarbe auf Weiß
                }
            }
            .frame(height: 60) // Setzt die Höhe des Buttons
            .padding(.horizontal, 60) // Setzt die horizontale Polsterung
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `AddIntakeButton`-Struktur.

 Diese Vorschau zeigt den `AddIntakeButton` in Xcode's SwiftUI Preview an.
 */
struct AddIntakeButton_Previews: PreviewProvider {
    static var previews: some View {
        AddIntakeButton(action: {})
    }
}

