//
//  CostumAddButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

/**
 Ein benutzerdefinierter Hinzufügen-Button, der eine angegebene Aktion ausführt, wenn er gedrückt wird.
 
 Dieser Button zeigt ein Symbol an und führt eine benutzerdefinierte Aktion aus, die als Parameter übergeben wird.

 - Properties:
    - action: Eine Schließung, die die Aktion definiert, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct CustomAddButton: View {
    /// Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            // Führt die angegebene Aktion aus
            self.action()
        }) {
           
                Image(systemName: "plus.circle.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.blue)
                    .font(.system(size: 32, weight: .bold))
            }
            
        }
    }

