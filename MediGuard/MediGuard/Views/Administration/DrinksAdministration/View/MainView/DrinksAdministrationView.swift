//
//  DrinksDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//


import SwiftUI

struct DrinksAdministrationView: View {
    @StateObject private var viewModel = DrinksAdministrationViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel

    /// Control progress
    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000

    /// Control alerts
    @State private var showInfo: Bool = false
    @State private var showSettings: Bool = false
    @State private var showCreateIntake: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text(DateHelper.formatFullDate(date: Date()))
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)
                    Text("Hier ist Ihre Flüssigkeitsaufnahme")
                        .italic()
                }
                
                ZStack {
                    ProgressBar(progress: viewModel.progress, goal: goal, intakeAmount: viewModel.intakesAmount)
                        .frame(width: 200.0, height: 200.0)
                        .padding(40.0)
                }

                Spacer()
 
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
                            }
                            .onDelete { indexSet in
                                viewModel.deleteIntake(at: indexSet)
                            }
                        }
                        .listStyle(.plain)
                    }
                }

                Spacer()

                HStack(alignment: .center, spacing: 40) {
                    Button(action: {
                        showInfo.toggle()
                    }) {
                        Image(systemName: "info.bubble")
                            .foregroundStyle(.blue)
                            .scaleEffect(1.5)
                    }
                    .sheet(isPresented: $showInfo) {
                        NavigationStack {
                            InfoView()
                        }
                    }

                    DrinksAdministrationCostumButton(
                        text: "Eintrag hinzufügen",
                        systemImage: "plus.app"
                    ) {
                        showCreateIntake.toggle()
                    }
                    .sheet(isPresented: $showCreateIntake) {
                        NavigationStack {
                            AddIntakeView()
                                .environmentObject(viewModel)
                                .environmentObject(userViewModel)
                        }
                        .presentationDetents([.medium])
                    }

                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.blue)
                            .scaleEffect(1.5)
                    }
                    .sheet(isPresented: $showSettings) {
                        NavigationStack {
                            DrinksAdministrationSettingsView()
                                .environmentObject(viewModel)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .frame(height: 60)
            }
            .onAppear {
                if let userId = userViewModel.userId {
                    viewModel.fetchIntakes(userId: userId)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
            .navigationBarItems(trailing: NavigationLink(destination: DrinksDocumentationView().environmentObject(userViewModel)) {
                            Image(systemName: "clock.fill")
                                .font(.title)
                                .foregroundStyle(.blue)
                        })
        }
    }
}

struct DrinksAdministrationView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksAdministrationView()
            .environmentObject(UserViewModel())
    }
}












