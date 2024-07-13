//
//  SettingsView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

/**
 Die `SettingsView`-Struktur ist eine SwiftUI-View, die die Einstellungen der App darstellt.
 
 Diese View enthält Felder zur Eingabe und Speicherung des Notfallkontakts sowie Buttons zum Abmelden und Löschen des Benutzerkontos.
 
 - Eigenschaften:
 - `settingsViewModel`: Das `SettingsViewModel`-Objekt, das die Daten und Logik für die Einstellungen verwaltet.
 - `userViewModel`: Das `UserViewModel`-Objekt, das die Benutzerdaten und Authentifizierungslogik verwaltet.
 - `showAlert`: Ein `@State`-Bool-Wert, der angibt, ob der Alert angezeigt werden soll.
 */
struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showAlert = false
    
    
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // MARK: - Header
            
            // Anzeige des Titels "Einstellungen"
            Text("Einstellungen")
                .hugeTitleStyle()
            
            Spacer()
            
            // MARK: - Notfallkontakt-Eingabe
            VStack(alignment: .center, spacing: 10) {
                // Beschreibungstext für den Notfallkontakt
                Text("Hier den Notfallkontakt speichern")
                    .font(Fonts.body)
                    .foregroundStyle(.blue)
                
                // Eingabefeld für die Notfallkontakt-Telefonnummer
                TextField("Notfallkontakt Telefonnummer", text: $settingsViewModel.emergencyContact)
                    .padding()
                    .keyboardType(.phonePad)
                    .background(.white)
                    .cornerRadius(8)
                    .font(Fonts.headline)
                
                // Button zum Speichern des Notfallkontakts
                SaveEmergencyContactButton()
                    .environmentObject(settingsViewModel)
            }
            .padding(.bottom, 20)
            Spacer()
            // MARK: - Benutzerkonto
            VStack(alignment: .center, spacing: 10) {
                // Überschrift für den Account-Bereich
                Text("Account")
                    .font(Fonts.body)
                    .foregroundStyle(.blue)
                
                // Button zum Abmelden des Benutzers
                LogoutButton()
                    .environmentObject(userViewModel)
                
                // Button zum Löschen des Benutzerkontos
                DeleteAccountButton()
                    .environmentObject(userViewModel)
            }
            
            Spacer()
        }
        .padding()
        .background(Color("Background")) // Setzt den Hintergrund
        .navigationBarBackButtonHidden(true)// Versteckt den Zurück-Button in der Navigation Bar// Fügt einen benutzerdefinierten Zurück-Button hinzu
        .navigationBarItems(leading: CustomBackButton())
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            // Überwachung von Änderungen der Fehlermeldung und Anzeige des Alerts
            showAlert = !errorMessage.isEmpty
        }
        
    }
}

// MARK: - Vorschau

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
            .environmentObject(UserViewModel())
    }
}














