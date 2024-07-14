//
//  DrinksDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//
import SwiftUI


// MARK: - DrinksAdministrationView

/**
 Die Ansicht zur Verwaltung der Getränkeaufnahme.
 
 Diese Ansicht zeigt die aktuelle Flüssigkeitsaufnahme des Benutzers an, ermöglicht das Hinzufügen neuer Intakes und bietet Navigation zu weiteren Einstellungen und Informationen.
 
 - Properties:
    - viewModel: Das ViewModel zur Verwaltung der Getränkeaufnahme.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - goal: Das tägliche Ziel für die Flüssigkeitsaufnahme, gespeichert in den App-Einstellungen.
    - showInfo: Ein Bool zur Steuerung der Anzeige des Info-Sheets.
    - showSettings: Ein Bool zur Steuerung der Anzeige des Einstellungs-Sheets.
    - showCreateIntake: Ein Bool zur Steuerung der Anzeige des Sheets zum Hinzufügen eines neuen Intakes.
 */

struct DrinksAdministrationView: View {
    // MARK: - Properties
    @StateObject private var viewModel = DrinksAdministrationViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel

    /// Tägliches Ziel für die Flüssigkeitsaufnahme
    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000

    /// Bool zur Steuerung der Anzeige des Info-Sheets
    @State private var showInfo: Bool = false
    
    /// Bool zur Steuerung der Anzeige des Einstellungs-Sheets
    @State private var showSettings: Bool = false
    
    /// Bool zur Steuerung der Anzeige des Sheets zum Hinzufügen eines neuen Intakes
    @State private var showCreateIntake: Bool = false

    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Überschrift für die heutige Flüssigkeitsaufnahme
                VStack {
                    Text("Getrunken heute")
                        .hugeTitleStyle()
                }
                
                // Anzeige der Fortschrittsanzeige und des Info-Buttons

                ZStack(alignment: .topTrailing) {
                    // Fortschrittsanzeige für die Flüssigkeitsaufnahme
                    ProgressBar(progress: viewModel.progress, goal: goal, intakeAmount: viewModel.intakesAmount)
                        .frame(width: 200.0, height: 200.0)
                        .padding(40.0)
                   
                    // Info-Button
                    InfoButton(showInfo: $showInfo)
                        
                                            .padding(.trailing, 10)
                                            .padding(.top, 10)
                                            
                                            .sheet(isPresented: $showInfo) {
                                                NavigationStack {
                                                    InfoView()
                                                }
                                            }
                }

                Spacer()
 
                // Anzeige der Intakes oder einer leeren Ansicht
                ZStack {
                    if viewModel.intakes.isEmpty {
                        EmptyIntakesView()
                    } else {
                        List {
                            ForEach(viewModel.intakes) { intake in
                                IntakeRowView(intake: intake) { _ in
                                    if let userId = userViewModel.userId {
                                         viewModel.logIntake(intake, userId: userId)
                                        
                                    }
                                }
                                .cornerRadius(32)
                                .listRowBackground(Color("Background"))
                            }
                            .onDelete { indexSet in
                                viewModel.deleteIntake(at: indexSet)
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                Spacer()
                
                // HStack für den CustomAddIntakeButton
                HStack(alignment: .center, spacing: 40) {
                                    

                    CustomAddIntakeButton(showCreateIntake: $showCreateIntake)
                                          .sheet(isPresented: $showCreateIntake) {
                                              NavigationStack {
                                                  AddIntakeView()
                                                      .environmentObject(viewModel)
                                                      .environmentObject(userViewModel)
                                              }
                                              .presentationDetents([.medium])
                                          }

                  
                }
                .padding(.horizontal, 40)
                .frame(height: 60)
            }
            .onAppear {
                // Lädt die Intakes beim Erscheinen der Ansicht
                if let userId = userViewModel.userId {
                    viewModel.fetchIntakes(userId: userId)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                // Alert zur Anzeige von Fehlermeldungen
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                            leading: CustomBackButton(),
                            trailing: HStack {
                                DrinkDocumentationButton().environmentObject(userViewModel)
                                DrinkSettingsButton(showSettings: $showSettings) // Verschiebe den DrinkSettingsButton hierhin
                                    .sheet(isPresented: $showSettings) {
                                        NavigationStack {
                                            DrinksAdministrationSettingsView()
                                                .environmentObject(viewModel)
                                        }
                                    }
                            }
                        )
                    }
                    .background(Color("Background").ignoresSafeArea()) // Setzt den Hintergrund für die gesamte NavigationStack
                }
            }


// MARK: - Preview

/**
 Vorschau der DrinksAdministrationView-Struktur.

 Diese Vorschau zeigt die DrinksAdministrationView in Xcode's SwiftUI Preview an.
 */
struct DrinksAdministrationView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksAdministrationView()
            .environmentObject(UserViewModel())
    }
}












