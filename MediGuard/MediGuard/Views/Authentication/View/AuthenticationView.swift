//
//  AuthenticationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

/**
 Die `AuthenticationView`-Struktur ist eine SwiftUI-View, die die Benutzeroberfläche für die Benutzer-Authentifizierung darstellt.
 
 Diese View ermöglicht es dem Benutzer, sich anzumelden oder zu registrieren, basierend auf dem aktuellen Modus im `UserViewModel`.
 
 - Eigenschaften:
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Authentifizierungslogik und -daten verwaltet.
    - `isPasswordVisible`: Boolean-Wert, der angibt, ob das Passwort sichtbar ist.
    - `isConfirmPasswordVisible`: Boolean-Wert, der angibt, ob das Bestätigungspasswort sichtbar ist.
    - `showAlert`: Boolean-Wert, der angibt, ob ein Alert angezeigt werden soll.
 */
struct AuthenticationView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showAlert = false
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Logo und Header
            Spacer()
            VStack(spacing: 12) {
                // Anzeige des Logos der App
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                        
                
                // Header-Text, der je nach Modus entweder "Anmelden" oder "Registrieren" anzeigt
                Text(userViewModel.mode.headerText)
                    .foregroundStyle(.blue)
                    .font(Fonts.largeTitle)
            }
            .padding(.top, 50)
            
            
            
            // MARK: - Eingabefelder
            
            VStack(spacing: 12) {
                // Eingabefeld für den Namen
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(height: 50)
                    
                    TextField("Name", text: $userViewModel.name)
                        .padding()
                        .font(Fonts.headline)
                }
                
                
                
                // Bedingte Anzeige der Passwortfelder basierend auf dem Modus
                if userViewModel.mode == .register {
                    // Eingabefeld für das Passwort bei der Registrierung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                    // Eingabefeld zur Bestätigung des Passworts bei der Registrierung
                    PasswordField(title: "Passwort wiederholen", text: $userViewModel.confirmPassword, isVisible: $isConfirmPasswordVisible)
                } else {
                    // Eingabefeld für das Passwort bei der Anmeldung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                }
            }
            .textInputAutocapitalization(.never)// Deaktiviert die automatische Großschreibung für alle Textfelder in diesem VStack
            
            
            
            // MARK: - Authentifizierungsbutton
            
            // Primärer Button, um den Authentifizierungsvorgang zu starten
            AuthButton.authenticationButton(userViewModel: userViewModel, showAlert: $showAlert)
                .alert(isPresented: $showAlert) {
                    // Anzeige eines Alerts bei Fehlern
                    Alert(title: Text("Fehler"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
            Spacer()
            
            // MARK: - Modus wechseln
            
            // Button, um zwischen Anmelde- und Registrierungsmodus zu wechseln
            AuthModeSwitchButton.switchModeButton(userViewModel: userViewModel)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 36)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color("Background")) // Hier wird der Hintergrund gesetzt
        .edgesIgnoringSafeArea(.all)
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            // Überwachung von Änderungen der Fehlermeldung und Anzeige des Alerts
            showAlert = !errorMessage.isEmpty
        }
    }
       
}

// MARK: - Vorschau

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())
    }
}












