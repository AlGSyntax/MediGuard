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
                    .hugeTitleStyle()
                
                
            }
            .padding(.top, 20)
            
            List {
                // Durchläuft alle Wochentage
                ForEach(Weekday.allCases, id: \.self) { day in
                    Section(header:
                                HStack{
                        Spacer()
                        Text(day.name)
                            .font(Fonts.title1)// Setzt die Schriftart
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color.blue)// Hintergrundfarbe des Headers
                            .foregroundStyle(.white)// Schriftfarbe des Headers
                            .cornerRadius(8)// Abrundung des Headers
                            .shadow(color: .mint, radius: 1, x: 0, y: 7)// Schatten des Headers
                        Spacer()
                    }) {
                        // Filtert die Medikamente für den aktuellen Tag
                        let medicationsForDay = viewModel.medications.filter { $0.day == day.rawValue }
                        // Ermittelt die einzigartigen Einnahmezeiten für den Tag
                        let uniqueTimes = Set(medicationsForDay.map { $0.intakeTime })
                        
                        if medicationsForDay.isEmpty {
                            // Zeigt eine Nachricht, wenn keine Medikamente für den Tag vorhanden sind
                            Text("Keine Medikamente für diesen Tag.")
                                .foregroundStyle(.black)
                                .font(Fonts.headline)
                            
                        } else {
                            // Durchläuft die Einnahmezeiten für den Tag, sortiert nach Stunde und Minute
                            ForEach(Array(uniqueTimes).sorted(by: { $0.hour! < $1.hour! || ($0.hour! == $1.hour! && $0.minute! < $1.minute!) }), id: \.self) { time in
                                // Filtert die Medikamente, die zur gleichen Zeit eingenommen werden
                                let medicationsAtTime = medicationsForDay.filter { $0.intakeTime == time }
                                
                                // Header für die Einnahmezeit
                                Section(header: Text(String(format: "%02d:%02d", time.hour!, time.minute!))
                                    .font(Fonts.largeTitle)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .foregroundStyle(.blue)
                                    .cornerRadius(8)
                                    
                                        
                                ) {
                                    // Durchläuft die Medikamente für die aktuelle Einnahmezeit
                                    ForEach(medicationsAtTime, id: \.id) { medication in
                                        // Anzeige des MedicationCardView für jedes Medikament
                                        MedicationCardView(medication: medication, showNextIntakeDate: medication.nextIntakeDate != nil, onDelete: {
                                            medicationToDelete = medication
                                            showAlert = true
                                        }, onEdit: {
                                            medicationToEdit = medication
                                            showingEditMedicationSheet.toggle()
                                        })
                                        
                                        .listRowBackground(Color("Background"))
                                        .cornerRadius(20)// Abrundung der Kartenansicht
                                    }
                                }
                                .background(Color("Background"))
                                .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    .listRowBackground(Color("Background"))// Hintergrundfarbe der Listenreihe
                }
            }
            .listStyle(PlainListStyle())// Einfacher Listenstil
            .background(Color("Background"))// Hintergrundfarbe der Liste
            .cornerRadius(32)// Abrundung der Liste
        }
        .padding(.horizontal)
        .background(Color("Background"))// Hintergrundfarbe der Ansicht
        .navigationBarBackButtonHidden(true)// Versteckt den Zurück-Button in der Navigationsleiste
        .navigationBarItems(leading: CustomBackButton())// Benutzerdefinierter Zurück-Button
        .navigationBarItems(trailing: CustomAddButton(action: {
            showingAddMedicationSheet.toggle()// Zeigt das AddMedicationSheet an
        }))
        .sheet(isPresented: $showingAddMedicationSheet) {
            // SheetView zum Hinzufügen eines neuen Medikaments
            NavigationStack {
                AddMedicationSheetView(medicationViewModel: viewModel)
                    .environmentObject(userViewModel)
            }
        }
        .sheet(item: $medicationToEdit) { medication in
            NavigationStack {
                // SheetView zum Bearbeiten eines bestehenden Medikaments
                EditMedicationSheetView(medicationViewModel: viewModel, medication: medication)
                    .environmentObject(userViewModel)
            }
        }
        .alert(isPresented: $showAlert) {
            // Alert zum Bestätigen des Löschens eines Medikaments
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
            // Ruft die Medikamente des Benutzers ab, wenn die Ansicht erscheint
            if let userId = userViewModel.userId {
                viewModel.fetchMedications(userId: userId)
            }
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            // Zeigt einen Fehler-Alert an, wenn eine Fehlermeldung vorhanden ist
            showErrorAlert = !errorMessage.isEmpty
        }
    }
}

struct MedicationAdiminstrationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationAdiminstrationView()
            .environmentObject(UserViewModel())
    }
}

