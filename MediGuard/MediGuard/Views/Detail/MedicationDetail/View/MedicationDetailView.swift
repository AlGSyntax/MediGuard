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
                }
            }
            
            Spacer()
            
            CustomAddButton {
                showingAddMedicationSheet.toggle()
            }
            .padding(.bottom, 20)
            .sheet(isPresented: $showingAddMedicationSheet) {
                AddMedicationSheet(medicationViewModel: viewModel)
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
