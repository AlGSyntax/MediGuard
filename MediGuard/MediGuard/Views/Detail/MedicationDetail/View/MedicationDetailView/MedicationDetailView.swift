//
//  MedicationDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

// MARK: - MedicationDetailView

/**
 Die `MedicationDetailView`-Struktur ist eine SwiftUI-View, die die Detailansicht für Medikamente darstellt.
 
 Diese View zeigt eine Liste von Medikamenten und ermöglicht das Hinzufügen, Bearbeiten und Löschen von Medikamenten.
 
 - Eigenschaften:
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Benutzerdaten und Authentifizierungslogik verwaltet.
    - `viewModel`: Das `MedicationDetailViewModel`-Objekt, das die Daten und Logik für die Detailansicht von Medikamenten verwaltet.
    - `showingAddMedicationSheet`: Ein Boolescher Zustand, der angibt, ob das Blatt zum Hinzufügen eines neuen Medikaments angezeigt wird.
    - `showingEditMedicationSheet`: Ein Boolescher Zustand, der angibt, ob das Blatt zum Bearbeiten eines Medikaments angezeigt wird.
    - `medicationToEdit`: Das Medikament, das bearbeitet wird. Wird verwendet, um das Bearbeitungsblatt zu initialisieren.
 */
struct MedicationDetailView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var viewModel = MedicationDetailViewModel()

    @State private var showingAddMedicationSheet = false
    @State private var showingEditMedicationSheet = false
    @State private var medicationToEdit: Medication?

    // MARK: - Body
    var body: some View {
        VStack {
            // MARK: - Header
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
            
            // MARK: - Liste der Medikamente
            List {
                ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) { day in
                    VStack(alignment: .leading) {
                        // MARK: - Tag-Header
                        Text(day)
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK: - Uhrzeit-Sektionen
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) { time in
                            VStack(alignment: .leading) {
                                Text(time)
                                    .font(.headline)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 10)

                                // MARK: - Filter für intakeTime
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

                                // MARK: - Filter für nextIntakeDate
                                ForEach(viewModel.medications.filter {
                                    guard let nextIntakeDate = $0.nextIntakeDate else { return false }
                                    let hourMinute = String(format: "%02d:%02d", nextIntakeDate.hour ?? 0, nextIntakeDate.minute ?? 0)
                                    let nextDay = Weekday.from(nextIntakeDate.weekday)?.name ?? "Unbekannt"
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
}

// MARK: - Vorschau

struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView()
            .environmentObject(UserViewModel())
    }
}








