//
//  SwiftUIView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

// MARK: - CustomAddIntakeButton

/**
 Ein benutzerdefinierter Button, der einen Text und ein Symbol anzeigt und eine Aktion ausführt, wenn er gedrückt wird.

 Der `CustomAddIntakeButton` zeigt ein Symbol und einen Text an und öffnet ein Sheet zum Hinzufügen eines neuen Intakes.
 
 - Properties:
    - showCreateIntake: Ein Binding-Bool-Wert, der die Anzeige des Sheets steuert.
 */
struct CustomAddIntakeButton: View {
    @Binding var showCreateIntake: Bool

    var body: some View {
        Button(action: {
            // Wechselt den Wert von `showCreateIntake`, um das Sheet anzuzeigen oder zu verbergen
            showCreateIntake.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(.blue) // Setzt die Farbe des Hintergrunds auf Blau

                HStack {
                    Text("Eintrag hinzufügen")
                        .font(Fonts.body)
                        .foregroundStyle(.white)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(Fonts.headline)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `CustomAddIntakeButton`-Struktur.

 Diese Vorschau zeigt den `CustomAddIntakeButton` in Xcode's SwiftUI Preview an.
 */
struct CustomAddIntakeButton_Previews: PreviewProvider {
    @State static var showCreateIntake = false
    static var previews: some View {
        CustomAddIntakeButton(showCreateIntake: $showCreateIntake)
    }
}




