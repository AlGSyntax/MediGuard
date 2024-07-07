//
//  DrinksDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct DrinksAdministrationView: View {
    @StateObject private var viewModel = DrinksAdiminstrationViewModel()
    @State private var currentCount: Int = 0
    
    var body: some View {
        VStack {
            Text("Wasseraufnahme")
                .font(.title)
                .padding()
            
            Text("Heute getrunken: \(currentCount) Gläser")
                .font(.title2)
                .padding()
            
            HStack {
                Button(action: {
                    currentCount += 1
                    viewModel.addWaterIntake(count: currentCount)
                }) {
                    Text("Glas hinzufügen")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    if currentCount > 0 {
                        currentCount -= 1
                        viewModel.addWaterIntake(count: currentCount)
                    }
                }) {
                    Text("Glas entfernen")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            List(viewModel.waterIntakes) { waterIntake in
                HStack {
                    Text("Datum: \(waterIntake.date, formatter: dateFormatter)")
                    Spacer()
                    Text("Gläser: \(waterIntake.count)")
                }
            }
        }
        .onAppear {
            viewModel.fetchWaterIntakes()
        }
        .alert(isPresented: Binding<Bool>(
            get: { !viewModel.errorMessage.isEmpty },
            set: { _ in viewModel.errorMessage = "" }
        )) {
            Alert(title: Text("Fehler"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct DrinksAdministration_Previews: PreviewProvider {
    static var previews: some View {
        DrinksAdministrationView()
    }
}

