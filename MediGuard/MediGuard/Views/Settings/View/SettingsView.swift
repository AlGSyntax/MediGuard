//
//  SettingsView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            Text("Einstellungen")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            TextField("Notfallkontakt Telefonnummer", text: $settingsViewModel.emergencyContact)
                .padding()
                .keyboardType(.phonePad)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
            
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
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}


