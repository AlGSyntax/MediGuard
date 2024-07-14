//
//  TextandBodyBlueModifier.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - Custom Modifiers for Text

extension Text {
    /**
     Ein benutzerdefinierter Modifier, der die Schriftart auf "body" setzt und die Vordergrundfarbe auf Blau ändert.
     
     - Returns: Eine modifizierte Text-Ansicht mit der Schriftart "body" und der Vordergrundfarbe Blau.
     */
    func bodyBlue() -> Text {
        self
            .font(Fonts.body)
            .foregroundColor(.blue)
    }
}


