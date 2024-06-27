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

struct MedicationDetailView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var viewModel = MedicationDetailViewModel()

    @State private var showingAddMedicationSheet = false
    @State private var showingEditMedicationSheet = false
    @State private var medicationToEdit: Medication?
    @State private var showAlert = false
    @State private var medicationToDelete: Medication?
    @State private var showErrorAlert = false

    // Vordefinierte Zeiten
    let predefinedTimes = ["08:00", "12:00", "16:00", "20:00"]
    
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                CustomBackButton()
                Spacer()
                Text("Medikamente")
                    .font(.title)
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
                // ForEach-Schleife zum Durchlaufen aller Wochentage
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
                        
                        // ForEach-Schleife zum Durchlaufen der vordefinierten Zeiten
                        ForEach(predefinedTimes, id: \.self) { time in
                            Section(header: Text(time)
                                        .font(.headline)
                                        .padding(.top, 5)
                                        .padding(.horizontal, 10)) {
                                
                                // Filtert die Medikamente nach Tag und Uhrzeit
                                let medicationsAtTime = viewModel.medications.filter {
                                    $0.day == day.name &&
                                    String(format: "%02d:%02d", $0.intakeTime.hour ?? 0, $0.intakeTime.minute ?? 0) == time
                                }
                                
                                // ForEach-Schleife zum Durchlaufen der gefilterten Medikamente
                                ForEach(medicationsAtTime, id: \.id) { medication in
                                    // Zeigt eine Karte für jedes Medikament an
                                    MedicationCardView(medication: medication, showNextIntakeDate: medication.nextIntakeDate != nil, onDelete: {
                                        // Setzt das zu löschende Medikament und zeigt das Löschbestätigungs-Alert an
                                        medicationToDelete = medication
                                        showAlert = true
                                    }, onEdit: {
                                        // Setzt das zu bearbeitende Medikament und zeigt das Bearbeitungs-Modal an
                                        medicationToEdit = medication
                                        showingEditMedicationSheet.toggle()
                                    })
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                                    .cornerRadius(20)
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
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
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


// Vorschau der MedicationDetailView
struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView()
            .environmentObject(UserViewModel())
    }
}
