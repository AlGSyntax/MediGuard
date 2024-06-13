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
            
            List {
                ForEach(viewModel.medications) { medication in
                    MedicationCardView(medicationName: medication.name, intakeTime: medication.intakeTime, nextIntakeDate: medication.nextIntakeDate)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteMedication(medication)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                            
                            Button {
                                medicationToEdit = medication
                                showingEditMedicationSheet.toggle()
                            } label: {
                                Label("Bearbeiten", systemImage: "pencil")
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

