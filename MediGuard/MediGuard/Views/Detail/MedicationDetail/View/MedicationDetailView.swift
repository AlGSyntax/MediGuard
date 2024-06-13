//
//  MedicationDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI
import Combine

struct MedicationDetailView: View {
    @StateObject private var viewModel: MedicationViewModel
    @State private var showingAddMedicationSheet = false
    @State private var showingEditMedicationSheet = false
    @State private var medicationToEdit: Medication?

    init(userViewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: MedicationViewModel(userViewModel: userViewModel))
    }
    
    var body: some View {
        VStack {
            Text("Medikamentenverwaltung")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            ScrollView {
                ForEach(viewModel.medications) { medication in
                    MedicationCardView(medicationName: medication.name, intakeTime: medication.intakeTime, nextIntakeDate: medication.nextIntakeDate)
                        .padding(.bottom, 10)
                        .swipeActions {
                            Button("Löschen") {
                                viewModel.deleteMedication(medication)
                            }
                            .tint(.red)
                            
                            Button("Bearbeiten") {
                                medicationToEdit = medication
                                showingEditMedicationSheet.toggle()
                            }
                            .tint(.blue)
                        }
                }
            }
            
            Spacer()
            
            CustomAddButton {
                showingAddMedicationSheet.toggle()
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $showingAddMedicationSheet) {
                AddMedicationSheetView(medicationViewModel: viewModel)
            }
            .sheet(item: $medicationToEdit) { medication in
               EditMedicationSheetView(medicationViewModel: viewModel, medication: medication)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: CustomBackButton()
        )
        .environmentObject(viewModel)
    }
}


struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView(userViewModel: UserViewModel())
    }
}

