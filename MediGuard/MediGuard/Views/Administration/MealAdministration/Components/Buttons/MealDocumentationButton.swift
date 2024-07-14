//
//  MealDocumentationButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.07.24.
//

import SwiftUI

/**
 Die `MealDocumentationButton`-Struktur stellt einen Button dar, der den Benutzer zur `MealDocumentationView` navigiert.
 
 Diese View-Komponente verwendet einen NavigationLink, um den Benutzer zur `MealDocumentationView` zu führen, wenn der Button gedrückt wird. Der Button zeigt ein Symbol (eine Uhr) an.
 
 - Properties:
    - userViewModel: Das ViewModel, das Benutzerdaten und Authentifizierungslogik enthält.
 */
struct MealDocumentationButton: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationLink(destination: MealDocumentationView().environmentObject(userViewModel)) {
            // Bildsymbol für den Button
            Image(systemName: "clock.fill")
                .font(.system(size: 34, weight: .bold)) // Setzt die Schriftart und Größe des Symbols
                .foregroundStyle(.blue) // Setzt die Vordergrundfarbe des Symbols auf Blau
                .aspectRatio(contentMode: .fit) // Setzt das Seitenverhältnis des Symbols
        }
    }
}

// MARK: - Preview

struct MealDocumentationButton_Previews: PreviewProvider {
    static var previews: some View {
        MealDocumentationButton()
            .environmentObject(UserViewModel()) // Beispiel-UserViewModel für die Vorschau
    }
}


