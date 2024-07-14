//
//  HeadlineBlueExtension.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - Custom Modifiers

extension View {
    /**
     Ein benutzerdefinierter Modifier, der die Schriftart auf "headline" setzt und die Vordergrundfarbe auf Blau ändert.
     
     - Returns: Eine modifizierte Ansicht mit der Schriftart "headline" und der Vordergrundfarbe Blau.
     */
    func headlineBlue() -> some View {
        self
            .font(Fonts.headline)
            .foregroundColor(.blue)
    }
}



