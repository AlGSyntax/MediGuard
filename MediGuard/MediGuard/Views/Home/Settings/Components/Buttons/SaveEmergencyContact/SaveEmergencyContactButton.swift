//
//  SaveEmergencyContactButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 16.06.24.
//

import SwiftUI

/**
 Die `SaveEmergencyContactButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button zum Speichern des Notfallkontakts darstellt.
 
 Dieser Button ruft die `saveEmergencyContact`-Funktion aus dem `SettingsViewModel` auf.
 */
struct SaveEmergencyContactButton: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            settingsViewModel.saveEmergencyContact()
        }) {
            Text("Speichern")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

// MARK: - Vorschau

struct SaveEmergencyContactButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveEmergencyContactButton()
            .environmentObject(SettingsViewModel())
    }
}

