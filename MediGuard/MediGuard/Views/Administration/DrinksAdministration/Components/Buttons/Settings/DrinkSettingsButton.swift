//
//  SettingsButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - DrinkSettingsButton

/**
 Ein benutzerdefinierter Button, der ein Symbol anzeigt und das Einstellungs-Sheet öffnet.
 
 Der `DrinkSettingsButton` verwendet einen Button, um das Einstellungs-Sheet zu öffnen.
 
 - Properties:
    - showSettings: Ein Binding-Bool-Wert, der die Anzeige des Einstellungs-Sheets steuert.
 */
struct DrinkSettingsButton: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        Button(action: {
            showSettings.toggle()
        }) {
            Image(systemName: "gearshape.circle.fill")
                .font(.system(size: 34)) // Setzt die Schriftart und Größe des Symbols
                .foregroundStyle(.blue) // Setzt die Vordergrundfarbe des Symbols auf Blau
                .aspectRatio(contentMode: .fit) // Setzt das Seitenverhältnis des Symbols
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `DrinkSettingsButton`-Struktur.
 
 Diese Vorschau zeigt den `DrinkSettingsButton` in Xcode's SwiftUI Preview an.
 */
struct DrinkSettingsButton_Previews: PreviewProvider {
    @State static var showSettings = false
    static var previews: some View {
        DrinkSettingsButton(showSettings: $showSettings)
    }
}
