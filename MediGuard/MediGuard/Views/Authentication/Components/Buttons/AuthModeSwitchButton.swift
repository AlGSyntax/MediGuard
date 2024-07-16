//
//  TextButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//



import SwiftUI

// MARK: - AuthModeSwitchButton

/**
 Die `AuthModeSwitchButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button darstellt, der nur Text enthält.
 
 Dieser Button wird in der `AuthenticationView` verwendet, um zwischen den Authentifizierungsmodi (Anmelden und Registrieren) zu wechseln.
 
 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct AuthModeSwitchButton: View {
    
    // MARK: - Variables
    
    /// Der Text, der auf dem Button angezeigt wird.
    let title: String
    
    /// Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
    let action: () -> Void
    
    // MARK: - Body
    
    /// Die Benutzeroberfläche des Buttons.
    var body: some View {
        Button(action: action) {
            // Text, der auf dem Button angezeigt wird
            Text(title)
                .font(Fonts.title1) // Setzt die Schriftart auf "title1" (eine vordefinierte Schriftart)
                .frame(maxWidth: .infinity) // Der Text nimmt die maximale verfügbare Breite ein
        }
    }
}

// MARK: - Erweiterung für spezifische Logik

/**
 Erweiterung der `AuthModeSwitchButton`-Struktur für spezifische Logik.
 
 Diese Erweiterung enthält eine statische Methode, um einen `AuthModeSwitchButton` zu erstellen,
 der die Authentifizierungsmodi wechselt, wenn er gedrückt wird.
 */
extension AuthModeSwitchButton {
    
    /**
         Erstellt einen `AuthModeSwitchButton`, der die Authentifizierungsmodi im `UserViewModel` wechselt und das Textfeld für den Wohnort im `CityViewModel` leert.
         
         - Parameters:
           - userViewModel: Das `UserViewModel`-Objekt, das die Authentifizierungslogik und -daten verwaltet.
           - cityViewModel: Das `CityViewModel`-Objekt, das die Suchlogik und -daten für Städte verwaltet.
         - Returns: Ein `AuthModeSwitchButton`, der die Authentifizierungsmodi wechselt und das Textfeld für den Wohnort leert.
         */
    @MainActor static func switchModeButton(userViewModel: UserViewModel, cityViewModel: CityViewModel) -> AuthModeSwitchButton {
        return AuthModeSwitchButton(title: userViewModel.mode.alternativeTitle) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 1)) {
                userViewModel.switchAuthenticationMode()
                cityViewModel.clearSearchText()// Wechselt den Authentifizierungsmodus im ViewModel
            }
        }
    }
}

// MARK: - Vorschau

/**
 Vorschau der `AuthModeSwitchButton`-Struktur.
 
 Diese Vorschau ermöglicht es, den Button in Xcode's SwiftUI Preview zu sehen.
 */
struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthModeSwitchButton(title: "Anmelden") { }
    }
}


