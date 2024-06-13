//
//  EditMedicationSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

struct EditMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationViewModel
    @State var medication: Medication

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name des Medikaments")) {
                    TextField("Name", text: $medication.name)
                }
                
                Section(header: Text("Uhrzeit der Einnahme")) {
                    TextField("Uhrzeit", text: $medication.intakeTime)
                }
                
                Section(header: Text("Nächstes Einnahmedatum")) {
                    TextField("Datum", text: $medication.nextIntakeDate)
                }
            }
            .navigationBarTitle("Medikament bearbeiten", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Speichern") {
                medicationViewModel.updateMedication(medication)
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditMedicationSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditMedicationSheetView(medicationViewModel: MedicationViewModel(userViewModel: UserViewModel()), medication: Medication(name: "Aspirin", intakeTime: "08:00 Uhr", nextIntakeDate: "12.06.2024"))
    }
}

