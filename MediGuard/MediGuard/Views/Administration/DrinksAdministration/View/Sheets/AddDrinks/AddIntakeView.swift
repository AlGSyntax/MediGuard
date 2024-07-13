//
//  AddIntakeView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
import SwiftUI

struct AddIntakeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var drinksViewModel: DrinksAdministrationViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var selectedType: IntakeTypeColor = .wasser
    @State private var selectedAmount: Int = 100

    private let amounts = stride(from: 100, through: 2000, by: 50).map { $0 }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Neue Eingabe")
                .font(.title)
                .bold()

            HStack {
                Picker("Wählen Sie aus", selection: $selectedType) {
                    ForEach(IntakeTypeColor.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Image(systemName: "drop.fill")
                    .foregroundColor(selectedType.color)
                    .font(.system(size: 40))
            }

            Picker("Wählen Sie eine Menge", selection: $selectedAmount) {
                ForEach(amounts, id: \.self) { item in
                    Text("\(item) mL")
                }
            }
            .pickerStyle(.inline)

            DrinksAdministrationCostumButton(
                text: "Speichern",
                systemImage: "square.and.arrow.down",
                action: {
                    if let userId = userViewModel.userId {
                        let newIntake = Intake(
                            amount: selectedAmount,
                            type: selectedType.rawValue,
                            time: Date()
                        )
                        drinksViewModel.addIntake(
                            amount: newIntake.amount,
                            type: newIntake.type,
                            time: newIntake.time,
                            userId: userId
                        )
                        dismiss()
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 60)
        }
        .padding()
    }
}

struct AddIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddIntakeView()
                .environmentObject(DrinksAdministrationViewModel())
                .environmentObject(UserViewModel())
        }
    }
}
