//
//  Settings.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

/**
 Die `SettingsButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button zur Navigation zu den Einstellungen darstellt.
 
 Dieser Button wird in der `HomeView` verwendet, um die Einstellungen der App zu öffnen.

 - Eigenschaften:
    - `iconName`: Der Name des Symbols, das auf dem Button angezeigt wird.
 */
struct SettingsButton: View {
    
    // MARK: - Body
    
    var body: some View {
        // Symbol auf dem Button
        Image(systemName: "gearshape.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 48, height: 48)
            .foregroundStyle(.primary)
    }
}

// MARK: - Vorschau

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}


