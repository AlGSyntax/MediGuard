//
//  AddMedicationSheet.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

struct AddMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationViewModel
    
    @State private var medicationName: String = ""
    @State private var intakeTime: String = ""
    @State private var nextIntakeDate: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name des Medikaments")) {
                    TextField("Name", text: $medicationName)
                }
                
                Section(header: Text("Uhrzeit der Einnahme")) {
                    TextField("Uhrzeit", text: $intakeTime)
                }
                
                Section(header: Text("Nächstes Einnahmedatum")) {
                    TextField("Datum", text: $nextIntakeDate)
                }
            }
            .navigationBarTitle("Neues Medikament", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Hinzufügen") {
                medicationViewModel.addMedication(name: medicationName, intakeTime: intakeTime, nextIntakeDate: nextIntakeDate)
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddMedicationSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddMedicationSheetView(medicationViewModel: MedicationViewModel(userViewModel: UserViewModel()))
    }
}

