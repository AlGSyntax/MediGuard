//
//  PrimaryButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

/**
 Die `PrimaryButton`-Struktur ist eine SwiftUI-View-Komponente, die einen primären Aktionsbutton darstellt.
 
 Dieser Button wird in der `AuthenticationView` verwendet, um Aktionen wie Anmelden oder Registrieren auszuführen.

 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct PrimaryButton: View {
    
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
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .background(Color.blue)
        .cornerRadius(12)
    }
}

// MARK: - Vorschau

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Login") { }
    }
}
