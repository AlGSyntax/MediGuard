//
//  MedicationCardView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

struct MedicationCardView: View {
    var medicationName: String
    var intakeTime: String
    var nextIntakeDate: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(medicationName)
                .font(.title)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text(intakeTime)
                .font(.title)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text(nextIntakeDate)
                .font(.title)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct MedicationCardView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationCardView(medicationName: "Aspirin", intakeTime: "08:00 Uhr", nextIntakeDate: "12.06.2024")
    }
}



