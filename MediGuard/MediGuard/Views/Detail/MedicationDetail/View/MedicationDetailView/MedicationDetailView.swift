//
//  MedicationDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct MedicationDetailView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var viewModel = MedicationDetailViewModel()

    @State private var showingAddMedicationSheet = false
    @State private var showingEditMedicationSheet = false
    @State private var medicationToEdit: Medication?

    var body: some View {
        VStack {
            HStack {
                CustomBackButton()
                Spacer()
                Text("Medikamente")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    showingAddMedicationSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 20)
            
            List {
                ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) { day in
                    VStack(alignment: .leading) {
                        Text(day)
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) { time in
                            VStack(alignment: .leading) {
                                Text(time)
                                    .font(.headline)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 10)

                                // Filter für intakeTime
                                ForEach(viewModel.medications.filter {
                                    let hourMinute = String(format: "%02d:%02d", $0.intakeTime.hour ?? 0, $0.intakeTime.minute ?? 0)
                                    return $0.day == day && hourMinute == time
                                }) { medication in
                                    MedicationCardView(medication: medication, onDelete: {
                                        viewModel.deleteMedication(medication, userId: userViewModel.userId ?? "")
                                    }, onEdit: {
                                        medicationToEdit = medication
                                        showingEditMedicationSheet.toggle()
                                    })
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                }

                                // Filter für nextIntakeDate
                                ForEach(viewModel.medications.filter {
                                    guard let nextIntakeDate = $0.nextIntakeDate else { return false }
                                    let hourMinute = String(format: "%02d:%02d", nextIntakeDate.hour ?? 0, nextIntakeDate.minute ?? 0)
                                    let nextDay = getDayString(from: nextIntakeDate.weekday)
                                    return nextDay == day && hourMinute == time
                                }) { medication in
                                    MedicationCardView(medication: medication, onDelete: {
                                        viewModel.deleteMedication(medication, userId: userViewModel.userId ?? "")
                                    }, onEdit: {
                                        medicationToEdit = medication
                                        showingEditMedicationSheet.toggle()
                                    })
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding([.leading, .trailing, .bottom], 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingAddMedicationSheet) {
            AddMedicationSheetView(medicationViewModel: viewModel)
                .environmentObject(userViewModel)
        }
        .sheet(item: $medicationToEdit) { medication in
            EditMedicationSheetView(medicationViewModel: viewModel, medication: medication)
                .environmentObject(userViewModel)
        }
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchMedications(userId: userId)
            }
        }
    }

    private func getDayString(from weekday: Int?) -> String? {
        guard let weekday = weekday else { return nil }
        switch weekday {
        case 2: return "Montag"
        case 3: return "Dienstag"
        case 4: return "Mittwoch"
        case 5: return "Donnerstag"
        case 6: return "Freitag"
        case 7: return "Samstag"
        case 1: return "Sonntag"
        default: return nil
        }
    }
}

struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView()
            .environmentObject(UserViewModel())
    }
}







