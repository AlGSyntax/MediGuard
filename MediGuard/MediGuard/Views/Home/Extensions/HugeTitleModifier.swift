//
//  HugeTitleModifier.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.07.24.
//

import SwiftUI

// MARK: - Custom View Modifier

/// Ein benutzerdefinierter ViewModifier, der mehrere Modifier kombiniert.
/// ViewModifier ist ein Protokoll, das eine Methode `body(content:)` erfordert,
/// in der die gewünschten Modifikationen auf das übergebene Content-Element angewendet werden.
struct HugeTitleModifier: ViewModifier {
    
    /// Diese Methode definiert, wie das Content-Element verändert wird.
    /// - Parameter content: Das ursprüngliche View-Element, auf das die Modifikationen angewendet werden.
    /// - Returns: Das modifizierte View-Element.
    func body(content: Content) -> some View {
        content
            .font(Fonts.hugeTitle)        // Setzt die Schriftart auf `hugeTitle` aus der `Fonts`-Sammlung.
            .padding(.top, 16)            // Fügt einen oberen Padding von 16 Einheiten hinzu.
            .foregroundStyle(.blue)       // Setzt die Vordergrundfarbe auf Blau.
    }
}

// MARK: - View Extension

/// Erweiterung des `View`-Protokolls, um den benutzerdefinierten Modifier einfacher anzuwenden.
/// Diese Erweiterung fügt eine Methode hinzu, die den `HugeTitleModifier` auf eine View anwendet.
extension View {
    
    /// Ein benutzerdefinierter Modifier für große Titel mit spezifischen Stilen.
    /// Diese Methode kann auf jede View angewendet werden, um den `HugeTitleModifier` anzuwenden.
    /// - Returns: Die View, modifiziert durch den `HugeTitleModifier`.
    func hugeTitleStyle() -> some View {
        self.modifier(HugeTitleModifier()) // Wendet den `HugeTitleModifier` auf die View an.
    }
}

