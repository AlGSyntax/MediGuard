//
//  DrinksAdministrationSettingsView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//


import SwiftUI

// MARK: - DrinksAdministrationSettingsView

/**
 Eine Ansicht zur Verwaltung der Einstellungen für die Flüssigkeitsaufnahme.

 Diese Ansicht ermöglicht es dem Benutzer, das tägliche Trinkziel zu setzen. Die Daten werden über das `DrinksAdministrationViewModel` verwaltet.
 
 - Properties:
    - vm: Das ViewModel zur Verwaltung der Einstellungen, bereitgestellt durch die Umgebung.
    - dismiss: Die Umgebungsvariable zum Schließen der Ansicht.
    - goal: Das tägliche Trinkziel, gespeichert in den App-Einstellungen.
 */
struct DrinksAdministrationSettingsView: View {
    // MARK: - Properties

    /// Das ViewModel zur Verwaltung der Einstellungen, bereitgestellt durch die Umgebung
    @EnvironmentObject var vm: DrinksAdministrationViewModel
    
    /// Die Umgebungsvariable zum Schließen der Ansicht
    @Environment(\.dismiss) private var dismiss

    /// Das tägliche Trinkziel, gespeichert in den App-Einstellungen
    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                // Section zur Einstellung des täglichen Trinkziels
                Section(header: Text("Wie viel willst du heute trinken?")
                    .headlineBlue()) {
                    // Picker zur Auswahl des täglichen Trinkziels
                    Picker("Setze dein Ziel!", selection: $goal) {
                        ForEach(stride(from: 500, through: 4001, by: 500).map { $0 }, id: \.self) { goal in
                            Text("\(goal) mL")
                        }
                    }
                    .pickerStyle(.menu) // Setzt den Picker-Stil auf Menü
                    .accentColor(.blue)  // Ändert die Farbe des Pickers entsprechend dem Design
                }
                .customSectionStyle() // Wendet einen benutzerdefinierten Stil auf die Section an
            }
            .toolbar {
                // ToolbarItem zum Schließen der Ansicht
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Setzt den Titel der NavigationBar auf inline
            .alert(isPresented: $vm.showAlert) {
                Alert(
                    title: Text(vm.alertTitle),
                    message: Text(vm.alertMessage)
                )
            }
        }
        .background(Color("Background").ignoresSafeArea()) // Setzt den Hintergrund für die gesamte NavigationStack
    }
}

// MARK: - Preview

/**
 Vorschau der `DrinksAdministrationSettingsView`-Struktur.

 Diese Vorschau zeigt die `DrinksAdministrationSettingsView` in Xcode's SwiftUI Preview an.
 */
struct DrinksAdministrationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DrinksAdministrationSettingsView()
                .environmentObject(DrinksAdministrationViewModel())
        }
    }
}


