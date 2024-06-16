//
//  EmergencyButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

/**
 Die `EmergencyCallButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Notruf-Button darstellt.
 
 Dieser Button wird in der `HomeView` verwendet, um einen Notruf zu tätigen.

 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
    - `iconName`: Der Name des Symbols, das auf dem Button angezeigt wird.
 */
struct EmergencyCallButton: View {
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    let iconName: String
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Symbol auf dem Button
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white)
                
                // Text auf dem Button
                Text(title)
                    .font(.largeTitle)
            }
            .padding()
            .background(Color.red)
            .foregroundStyle(.white)
            .cornerRadius(24)
        }
    }
}

// MARK: - Vorschau

struct EmergencyCallButton_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyCallButton(title: "Notruf", action: {}, iconName: "phone.fill")
    }
}




