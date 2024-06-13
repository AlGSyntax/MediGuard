//
//  MedicationDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI


struct MedicationDetailView: View {
    @StateObject private var viewModel = MedicationViewModel()
    
    var body: some View {
        VStack {
            Text("Medikamente")
                .font(.largeTitle)
                .padding(.bottom, 40)
                .foregroundStyle(.blue)
            
            // Hier können später CardViews hinzugefügt werden
            
            Spacer()
            
            CustomAddButton {
                // Aktion für den Hinzufügen-Button
                print("Hinzufügen-Button gedrückt")
            }
            .padding(.bottom, 20)
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: CustomBackButton()
        )
        .environmentObject(viewModel)
    }
}
