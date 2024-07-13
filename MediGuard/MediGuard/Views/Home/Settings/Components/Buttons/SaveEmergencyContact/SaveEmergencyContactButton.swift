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
 
 - Eigenschaften:
    - `settingsViewModel`: Das `SettingsViewModel`-Objekt, das die Daten und Logik für die Einstellungen verwaltet.
    - `showAlert`: Ein `@State`-Bool-Wert, der angibt, ob der Alert angezeigt werden soll.
 */
struct SaveEmergencyContactButton: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var showAlert = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            // Zeigt den Alert an, wenn der Button gedrückt wird
            showAlert = true
        }) {
            Text("Speichern")
                .font(Fonts.body)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
            // Definiert den Alert, der angezeigt wird
                    Alert(
                        title: Text("Nummer speichern"),
                        message: Text("Sind Sie sicher, dass Sie die veränderte Nummer speichern möchten?"),
                        primaryButton: .destructive(Text("Speichern")) {
                            // Ruft die Methode `saveEmergencyContact` auf, wenn "Speichern" gedrückt wird
                            settingsViewModel.saveEmergencyContact()
                        },
                        secondaryButton: .cancel()
                    )
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

