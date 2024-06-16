//
//  TextButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//



import SwiftUI

/**
 Die `TextButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button darstellt, der nur Text enthält.
 
 Dieser Button wird in der `AuthenticationView` verwendet, um zwischen den Authentifizierungsmodi (Anmelden und Registrieren) zu wechseln.
 
 - Eigenschaften:
 - `title`: Der Text, der auf dem Button angezeigt wird.
 - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct TextButton: View {
    
    
    
    
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            // Text, der auf dem Button angezeigt wird
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
            
        }
    }
    
}

// MARK: - Vorschau
struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(title: "Anmelden") { }
    }
}
