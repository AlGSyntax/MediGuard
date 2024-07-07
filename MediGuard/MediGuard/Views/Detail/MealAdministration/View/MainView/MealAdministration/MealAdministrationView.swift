//
//  MealDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//
// MealDetailView.swift
import SwiftUI

/**
 Die Hauptansicht zur Verwaltung von Mahlzeiten.
 
 Diese Ansicht zeigt eine Liste von Mahlzeiten für die aktuelle Woche an und ermöglicht es dem Benutzer, neue Mahlzeiten hinzuzufügen oder bestehende Mahlzeiten zu bearbeiten.
 Die Daten werden über das `MealAdministrationViewModel` verwaltet.

 - Properties:
    - viewModel: Das ViewModel zur Verwaltung der Mahlzeiten.
    - showingAddMealSheet: Ein Zustand zur Steuerung der Anzeige des Sheets zum Hinzufügen von Mahlzeiten.
    - selectedDate: Das ausgewählte Datum für eine neue Mahlzeit.
    - selectedTime: Die ausgewählte Uhrzeit für eine neue Mahlzeit.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - times: Die vordefinierten Zeiten für Mahlzeiten.
 */
struct MealAdministrationView: View {
    
    // MARK: - Properties
    
    /// Das ViewModel zur Verwaltung der Mahlzeiten.
    @StateObject private var viewModel = MealAdministrationViewModel()
    
    /// Zustand zur Steuerung der Anzeige des Sheets zum Hinzufügen von Mahlzeiten.
    @State private var showingAddMealSheet = false
    
    /// Das ausgewählte Datum für eine neue Mahlzeit.
    @State private var selectedDate = Date()
    
    /// Die ausgewählte Uhrzeit für eine neue Mahlzeit.
    @State private var selectedTime: String = ""
    
    /// Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    @EnvironmentObject private var userViewModel: UserViewModel

    /// Die vordefinierten Zeiten für Mahlzeiten.
    let times = ["04:00", "08:00", "12:00", "16:00"]

    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    CustomBackButton()
                    Spacer()
                    VStack {
                        Text("Mahlzeiten")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Kurzwoche \(viewModel.currentWeekNumber())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    NavigationLink(destination: MealDocumentationView().environmentObject(userViewModel)) {
                        Image(systemName: "clock.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 20)

                List {
                    ForEach(viewModel.currentWeek(), id: \.self) { date in
                        if viewModel.isInCurrentWeek(date) && !viewModel.isInPast(date) {
                            Section(header: HStack {
                                let dayString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
                                Text(dayString)
                                    .font(.title2)
                                    .bold()
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .cornerRadius(8)
                                    .padding(.top, 10)
                            }) {
                                ForEach(times, id: \.self) { time in
                                    let mealsAtTime = viewModel.meals.filter { meal in
                                        let mealDate = Calendar.current.startOfDay(for: meal.intakeDate)
                                        return mealDate == date && DateFormatter.localizedString(from: meal.intakeDate, dateStyle: .none, timeStyle: .short) == time
                                    }
                                    
                                    Section(header: Text("")
                                        .font(.headline)
                                        .padding(.top, 5)) {
                                            HStack {
                                                Text("Nach \(time)")
                                                    .font(.headline)
                                                    .padding(.top, 5)
                                                Spacer()
                                                CustomAddButton(action: {
                                                    selectedDate = date
                                                    selectedTime = time
                                                    showingAddMealSheet.toggle()
                                                })
                                            }
                                            ForEach(mealsAtTime) { meal in
                                                MealCardView(meal: meal, onDelete: {
                                                    if let userId = userViewModel.userId {
                                                        viewModel.deleteMeal(meal, userId: userId)
                                                    }
                                                }, onEdit: {
                                                    selectedDate = meal.intakeDate
                                                    selectedTime = DateFormatter.localizedString(from: meal.intakeDate, dateStyle: .none, timeStyle: .short)
                                                    showingAddMealSheet.toggle()
                                                })
                                            }
                                            if mealsAtTime.isEmpty {
                                                Text("Noch keine Mahlzeiten hinterlegt")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
                .cornerRadius(32)
            }
            .padding(.horizontal)
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showingAddMealSheet) {
                NavigationStack {
                    AddMealSheetView(mealViewModel: viewModel, selectedDate: $selectedDate, selectedTime: $selectedTime)
                }
                .environmentObject(userViewModel)
            }

            .onAppear {
                if let userId = userViewModel.userId {
                    viewModel.fetchMeals(userId: userId)
                }
            }
        }
    }
}

// MARK: - Previews

struct MealAdministrationView_Previews: PreviewProvider {
    static var previews: some View {
        MealAdministrationView()
            .environmentObject(UserViewModel())
    }
}

