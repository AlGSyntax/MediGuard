//
//  SettingsView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

/**
 Die `SettingsView`-Struktur ist eine SwiftUI-View, die die Einstellungen der App darstellt.
 
 Diese View enthält Felder zur Eingabe und Speicherung des Notfallkontakts sowie einen Button zum Abmelden des Benutzers.

 - Eigenschaften:
    - `settingsViewModel`: Das `SettingsViewModel`-Objekt, das die Daten und Logik für die Einstellungen verwaltet.
 */
struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // MARK: - Header
            
            Text("Einstellungen")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            // MARK: - Notfallkontakt-Eingabe
            
            TextField("Notfallkontakt Telefonnummer", text: $settingsViewModel.emergencyContact)
                .padding()
                .keyboardType(.phonePad)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // MARK: - Speichern-Button
            
            SaveEmergencyContactButton()
                .environmentObject(settingsViewModel)
            
            // MARK: - Logout-Button
            
            LogoutButton()
                .environmentObject(userViewModel)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
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




