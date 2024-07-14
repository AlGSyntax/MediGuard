//
//  InfoButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//
import SwiftUI

// MARK: - InfoButton

/**
 Ein benutzerdefinierter Button, der ein Informationssymbol anzeigt und eine Aktion ausführt, wenn er gedrückt wird.

 Der `InfoButton` verwendet einen Binding-Wert, um die Anzeige eines Informationssheets zu steuern.
 
 - Properties:
    - showInfo: Ein Binding-Bool-Wert, der die Anzeige des Informationssheets steuert.
 */
struct InfoButton: View {
    @Binding var showInfo: Bool
    
    var body: some View {
        Button(action: {
            // Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
            // Wechselt den Wert von `showInfo`, um das Informationssheet anzuzeigen oder zu verbergen.
            showInfo.toggle()
        }) {
            // Darstellung des Buttons
            Image(systemName: "info.bubble.fill")
                .font(.system(size: 26, weight: .bold)) // Setzt die Schriftart und Größe des Symbols
                .foregroundStyle(.blue) // Setzt die Vordergrundfarbe des Symbols auf Blau
                .aspectRatio(contentMode: .fit) // Setzt das Seitenverhältnis des Symbols
                .scaleEffect(1.5) // Vergrößert das Symbol
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `InfoButton`-Struktur.

 Diese Vorschau zeigt den `InfoButton` mit einem Beispiel-Binding-Wert in Xcode's SwiftUI Preview an.
 */
struct InfoButton_Previews: PreviewProvider {
    @State static var showInfo = false

    static var previews: some View {
        InfoButton(showInfo: $showInfo)
    }
}
