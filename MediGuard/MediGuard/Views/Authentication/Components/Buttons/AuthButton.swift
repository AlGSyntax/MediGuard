//
//  PrimaryButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

// MARK: - PrimaryButton

/**
 Die `AuthButton`-Struktur ist eine SwiftUI-View-Komponente, die einen primären Aktionsbutton darstellt.
 
 Dieser Button wird in der `AuthenticationView` verwendet, um Aktionen wie Anmelden oder Registrieren auszuführen.

 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `action`: Die Aktion, die ausgeführt wird, wenn der Button gedrückt wird.
 */
struct AuthButton: View {
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            // Text, der auf dem Button angezeigt wird
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .background(Color.blue)
        .cornerRadius(12)
    }
}

// MARK: - Erweiterung für spezifische Logik

extension AuthButton {
    @MainActor static func authenticationButton(userViewModel: UserViewModel, showAlert: Binding<Bool>) -> AuthButton {
        return AuthButton(title: userViewModel.mode.title) {
            // Überprüfung, ob die Authentifizierung deaktiviert ist
            if userViewModel.disableAuthentication {
                // Fehlerbehandlung und entsprechende Fehlermeldungen
                if userViewModel.name.isEmpty {
                    userViewModel.errorMessage = "Bitte geben Sie einen Namen ein."
                } else if userViewModel.password.isEmpty {
                    userViewModel.errorMessage = "Bitte geben Sie ein Passwort ein."
                } else if userViewModel.mode == .register && userViewModel.confirmPassword.isEmpty {
                    userViewModel.errorMessage = "Bitte wiederholen Sie das Passwort."
                } else if userViewModel.mode == .register && userViewModel.password != userViewModel.confirmPassword {
                    userViewModel.errorMessage = "Die Passwörter stimmen nicht überein."
                }
                showAlert.wrappedValue = true
            } else {
                // Authentifizierungsvorgang starten
                userViewModel.authenticate()
                // Eingabefelder leeren nach der Authentifizierung
                userViewModel.clearFields()
            }
        }
    }
}

// MARK: - Vorschau

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(title: "Login") { }
    }
}

 
