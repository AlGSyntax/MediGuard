//
//  EmptyIntakesView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

/**
 Die `EmptyIntakesView`-Struktur ist eine benutzerdefinierte SwiftUI-View, die eine Nachricht anzeigt, wenn der Benutzer noch keine Flüssigkeitsaufnahme für den Tag hinzugefügt hat.
 
 Diese Ansicht enthält ein Symbol, zwei Textnachrichten und ein Pfeilsymbol, um den Benutzer zu motivieren, eine Flüssigkeitsaufnahme hinzuzufügen.

 - Properties:
    - body: Der Hauptinhalt der Ansicht.
 */
struct EmptyIntakesView: View {
    var body: some View {
        VStack {
            // Symbol für Flüssigkeitsaufnahme
            Image(systemName: "takeoutbag.and.cup.and.straw")
                .font(.system(size: 40)) // Setzt die Schriftgröße des Symbols
                .padding(.vertical, 10) // Fügt vertikales Padding hinzu
                .foregroundStyle(.blue) // Setzt die Farbe des Symbols auf Blau
            
            // Nachricht, dass noch nichts getrunken wurde
            Text("Noch nichts getrunken heute!")
                .headlineBlue() // Verwendet den benutzerdefinierten Modifier für die Schriftart und Farbe
            
            // Aufforderung, etwas zu trinken und hinzuzufügen
            Text("Trinke etwas und füge es hier hinzu")
                .headlineBlue() // Verwendet den benutzerdefinierten Modifier für die Schriftart und Farbe
            
            // Pfeilsymbol, das nach unten zeigt
            Image(systemName: "arrow.down")
                .padding() // Fügt Padding um das Symbol hinzu
        }
    }
}

// MARK: - Preview

/**
 Vorschau der `EmptyIntakesView`-Struktur.
 
 Diese Vorschau ermöglicht es, die Ansicht in Xcode's SwiftUI Preview zu sehen.
 */
struct EmptyIntakesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyIntakesView()
    }
}

