//
//  SectionHeaderModifier.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 17.07.24.
//

import SwiftUI

// MARK: - Custom Modifier for Section Header

extension View {
    /**
     Ein benutzerdefinierter Modifier, der dem Header mehr Größe, eine Hintergrundfarbe, Schriftfarbe, Corner-Radius und Schatten hinzufügt.
     
     - Returns: Eine modifizierte Ansicht mit den genannten Eigenschaften.
     */
    func customHeaderStyle() -> some View {
        self
            .font(Fonts.title1) // Setzt die Schriftart
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(Color.blue) // Hintergrundfarbe des Headers
            .foregroundColor(.white) // Schriftfarbe des Headers
            .cornerRadius(8) // Abrundung des Headers
            .shadow(color: .mint, radius: 1, x: 0, y: 7) // Schatten des Headers
    }
}

