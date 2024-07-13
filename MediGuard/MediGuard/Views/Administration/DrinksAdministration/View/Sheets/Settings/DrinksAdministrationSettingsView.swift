//
//  DrinksAdministrationSettingsView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//


import SwiftUI

struct DrinksAdministrationSettingsView: View {
    @EnvironmentObject var vm: DrinksAdministrationViewModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goals")) {
                    Picker("Set your goal", selection: $goal) {
                        ForEach(stride(from: 500, through: 4001, by: 500).map { $0 }, id: \.self) { goal in
                            Text("\(goal) mL")
                        }
                    }
                    .pickerStyle(.menu)
                    .accentColor(.blue)  // Ändere die Farbe entsprechend deinem Design
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $vm.showAlert) {
                Alert(
                    title: Text(vm.alertTitle),
                    message: Text(vm.alertMessage)
                )
            }
        }
    }
}

struct DrinksAdministrationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DrinksAdministrationSettingsView()
                .environmentObject(DrinksAdministrationViewModel())
        }
    }
}

