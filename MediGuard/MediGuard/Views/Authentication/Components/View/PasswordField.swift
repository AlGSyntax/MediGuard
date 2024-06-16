//
//  PasswordField.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

/**
 Die `PasswordField`-Struktur ist eine SwiftUI-View-Komponente, die ein Eingabefeld für Passwörter darstellt.
 
 Diese Komponente bietet die Möglichkeit, das Passwort sichtbar oder unsichtbar zu machen, indem ein Button verwendet wird, der das Symbol eines Auges anzeigt.
 
 - Eigenschaften:
 - `title`: Der Platzhaltertext für das Eingabefeld.
 - `text`: Die gebundene Variable, die den eingegebenen Text speichert.
 - `isVisible`: Eine gebundene Variable, die angibt, ob das Passwort sichtbar ist.
 */
struct PasswordField: View {
    
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Hintergrund des Passwortfelds
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
                .frame(height: 50)
            
            HStack {
                // Bedingte Anzeige des Textfelds basierend auf `isVisible`
                if isVisible {
                    // Normales Textfeld, wenn das Passwort sichtbar ist
                    TextField(title, text: $text)
                        .padding()
                } else {
                    // Sicheres Textfeld, wenn das Passwort unsichtbar ist
                    SecureField(title, text: $text)
                        .padding()
                }
                // Button, um die Sichtbarkeit des Passworts umzuschalten
                Button(action: {
                    isVisible.toggle()
                }) {
                    // Symbol, das die aktuelle Sichtbarkeit des Passworts anzeigt
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

// MARK: - Vorschau
struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(title: "Passwort", text: .constant(""), isVisible: .constant(false))
    }
}

