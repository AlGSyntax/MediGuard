//
//  MedicationDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//



import SwiftUI

// MARK: - MedicationDetailView

/**
 Die MedicationDetailView-Struktur ist eine SwiftUI-View, die die Detailansicht für Medikamente darstellt.
 
 Diese View zeigt eine Liste von Medikamenten und ermöglicht das Hinzufügen, Bearbeiten und Löschen von Medikamenten.
 
 - Eigenschaften:
    - userViewModel: Das UserViewModel-Objekt, das die Benutzerdaten und Authentifizierungslogik verwaltet.
    - viewModel: Das MedicationDetailViewModel-Objekt, das die Daten und Logik für die Detailansicht von Medikamenten verwaltet.
    - showingAddMedicationSheet: Ein Boolescher Zustand, der angibt, ob das Blatt zum Hinzufügen eines neuen Medikaments angezeigt wird.
    - showingEditMedicationSheet: Ein Boolescher Zustand, der angibt, ob das Blatt zum Bearbeiten eines Medikaments angezeigt wird.
    - medicationToEdit: Das Medikament, das bearbeitet wird. Wird verwendet, um das Bearbeitungsblatt zu initialisieren.
    - showAlert: Ein Boolescher Zustand, der angibt, ob ein Alert angezeigt werden soll.
    - medicationToDelete: Das Medikament, das gelöscht werden soll. Wird verwendet, um den Lösch-Alert zu initialisieren.
 */



struct MedicationAdiminstrationView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var viewModel = MedicationAdminstrationViewModel()

    @State private var showingAddMedicationSheet = false
    @State private var showingEditMedicationSheet = false
    @State private var medicationToEdit: Medication?
    @State private var showAlert = false
    @State private var medicationToDelete: Medication?
    @State private var showErrorAlert = false

    var body: some View {
        VStack {
            HStack {
                Text("Medikamente")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
               
            }
            .padding(.top, 20)
            
            List {
                ForEach(Weekday.allCases, id: \.self) { day in
                    Section(header: Text(day.name)
                                .font(.title2)
                                .bold()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, 10)) {
                        
                        let medicationsForDay = viewModel.medications.filter { $0.day == day.name }
                        let uniqueTimes = Set(medicationsForDay.map { $0.intakeTime })
                        
                        if medicationsForDay.isEmpty {
                            Text("Keine Medikamente für diesen Tag.")
                                .foregroundColor(.gray)
                                
                        } else {
                            ForEach(Array(uniqueTimes).sorted(by: { $0.hour! < $1.hour! || ($0.hour! == $1.hour! && $0.minute! < $1.minute!) }), id: \.self) { time in
                                let medicationsAtTime = medicationsForDay.filter { $0.intakeTime == time }
                                
                                Section(header: Text(String(format: "%02d:%02d", time.hour!, time.minute!))
                                            .font(.headline)
                                            
                                            ) {
                                    
                                    ForEach(medicationsAtTime, id: \.id) { medication in
                                        MedicationCardView(medication: medication, showNextIntakeDate: medication.nextIntakeDate != nil, onDelete: {
                                            medicationToDelete = medication
                                            showAlert = true
                                        }, onEdit: {
                                            medicationToEdit = medication
                                            showingEditMedicationSheet.toggle()
                                        })
                                        
                                        
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.white)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.white)
            .cornerRadius(32)
        }
        .padding(.horizontal)
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .navigationBarItems(trailing: CustomAddButton(action: {
            showingAddMedicationSheet.toggle()
        }))
        .sheet(isPresented: $showingAddMedicationSheet) {
            NavigationStack {
                AddMedicationSheetView(medicationViewModel: viewModel)
                    .environmentObject(userViewModel)
            }
        }
        .sheet(item: $medicationToEdit) { medication in
            NavigationStack {
                EditMedicationSheetView(medicationViewModel: viewModel, medication: medication)
                    .environmentObject(userViewModel)
            }
        }
        .alert(isPresented: $showAlert) {
            if let medicationToDelete = medicationToDelete {
                return Alert(
                    title: Text("Löschen bestätigen"),
                    message: Text("Möchten Sie dieses Medikament wirklich löschen?"),
                    primaryButton: .destructive(Text("Löschen")) {
                        viewModel.deleteMedication(medicationToDelete, userId: userViewModel.userId ?? "")
                    },
                    secondaryButton: .cancel(Text("Abbrechen"))
                )
            } else {
                return Alert(title: Text("Fehler"), message: Text("Es gibt kein Medikament zum Löschen."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchMedications(userId: userId)
            }
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            showErrorAlert = !errorMessage.isEmpty
        }
    }
}

struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationAdiminstrationView()
            .environmentObject(UserViewModel())
    }
}

