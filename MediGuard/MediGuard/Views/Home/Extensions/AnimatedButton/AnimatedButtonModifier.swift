//
//  AnimatedButtonModifier.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//
import SwiftUI

// MARK: - AnimatedButtonModifier

/**
 Ein `ViewModifier`, der eine animierte Reaktion auf das Klicken eines Buttons ermöglicht.
 
 Dieser Modifier handhabt den Zustand der Animation und führt die Aktion nach Abschluss der Animation aus.
 
 - Eigenschaften:
    - `action`: Die Aktion, die beim Klicken auf den Button ausgeführt wird. Der `@escaping`-Modifier ermöglicht es, dass die Aktion nach dem Abschluss der Animation ausgeführt wird.
 */
struct AnimatedButtonModifier: ViewModifier {
    @Binding var isNavigating: Bool
    let action: () -> Void
    @State private var isTapped = false

    /**
     `body(content:)` ist eine Methode, die den Inhalt des Modifiers definiert.
     
     - Parameter content: Der Inhalt, auf den der Modifier angewendet wird.
     - Returns: Eine modifizierte Ansicht mit Animationseffekten.
     */
    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 1.1 : 1.0) // Vergrößert die Ansicht beim Tap
            .opacity(isTapped ? 0.8 : 1.0) // Verringert die Deckkraft beim Tap
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isTapped = true // Startet die Animation beim Tap
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isTapped = false // Rücksetzung der Animation nach kurzer Verzögerung
                    }
                    isNavigating = true // Setzt den Navigationszustand
                    action() // Führt die Aktion aus, nachdem die Animation abgeschlossen ist
                }
            }
    }
}

/**
 Eine Erweiterung von `View`, die eine animierte Reaktion auf das Klicken eines Buttons ermöglicht.
 
 Diese Erweiterung fügt eine Animation hinzu, die den Button bei einem Tap vergrößert und die Deckkraft verringert, um visuelles Feedback zu geben.

 - Parameter action: Die Aktion, die beim Klicken auf den Button ausgeführt wird.
 - Returns: Eine Ansicht mit der hinzugefügten Animation.
 */
extension View {
    func animatedButton(isNavigating: Binding<Bool>, action: @escaping () -> Void) -> some View {
        modifier(AnimatedButtonModifier(isNavigating: isNavigating, action: action))
    }
}




