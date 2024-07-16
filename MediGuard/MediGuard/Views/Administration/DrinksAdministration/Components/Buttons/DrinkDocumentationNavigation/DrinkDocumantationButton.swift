//
//  DrinkDocumantationButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - DrinkDocumentationButton

/**
 Ein benutzerdefinierter Button, der ein Symbol anzeigt und zu einer Dokumentationsansicht navigiert.

 Der `DocumentationButton` verwendet eine NavigationLink, um zur `DrinksDocumentationView` zu navigieren.
 
 - Properties:
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
 */
struct DrinkDocumentationButton: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationLink(destination: DrinksDocumentationView().environmentObject(userViewModel)) {
            Image(systemName: "clock.fill")
                .font(.system(size: 34)) // Setzt die Schriftart und Größe des Symbols
                .foregroundStyle(.blue) // Setzt die Vordergrundfarbe des Symbols auf Blau
                .aspectRatio(contentMode: .fit) // Setzt das Seitenverhältnis des Symbols
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `DocumentationButton`-Struktur.

 Diese Vorschau zeigt den `DocumentationButton` in Xcode's SwiftUI Preview an.
 */
struct DrinkDocumentationButton_Previews: PreviewProvider {
    static var previews: some View {
        DrinkDocumentationButton()
            .environmentObject(UserViewModel())
    }
}

