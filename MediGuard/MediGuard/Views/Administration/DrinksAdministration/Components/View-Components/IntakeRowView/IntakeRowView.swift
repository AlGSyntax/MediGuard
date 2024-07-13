//
//  IntakeRowView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

struct IntakeRowView: View {
    var intake: Intake
    var selectedIntake: (Intake) -> Void

    var body: some View {
        HStack {
            Text("\(intake.amount) mL")
                .bold()

            Spacer()

            Image(systemName: "heart")
                            .symbolVariant(.fill)
                            .foregroundStyle(.red)
                            .onTapGesture {
                                selectedIntake(intake)
                            }
            HStack {
                Text(intake.type)
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: "drop")
                    .symbolVariant(.fill)
                    .foregroundColor(IntakeTypeColor(rawValue: intake.type)?.color ?? .gray)
            }
            .frame(width: 80, alignment: .trailing)

            Text(DateHelper.formatTime(date: intake.time))
                .frame(width: 80, alignment: .trailing)
        }
        .padding(.vertical, 10)
    }

   
}

struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: Intake(amount: 250, type: "Wasser", time: Date())) { _ in }
    }
}



