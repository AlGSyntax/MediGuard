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
    
    @StateObject private var viewModel = MealAdministrationViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var showingAddMealSheet = false
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var mealToDelete: Meal? = nil
    @State private var showAlert = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack {
                        Text("Mahlzeiten")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Kalendarwoche \(viewModel.currentWeekNumber())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(.top, 10)
                            }) {
                                let mealsForDay = viewModel.meals.filter { meal in
                                    let mealDate = Calendar.current.startOfDay(for: meal.intakeDate)
                                    return mealDate == date
                                }
                                
                                let uniqueTimes = Set(mealsForDay.map { Calendar.current.dateComponents([.hour, .minute], from: $0.intakeDate) })
                                let sortedTimes = Array(uniqueTimes).sorted {
                                    ($0.hour ?? 0) < ($1.hour ?? 0) || (($0.hour ?? 0) == ($1.hour ?? 0) && ($0.minute ?? 0) < ($1.minute ?? 0))
                                }
                                
                                if mealsForDay.isEmpty {
                                    Text("Noch keine Mahlzeiten hinterlegt")
                                        .foregroundColor(.gray)
                                } else {
                                    ForEach(sortedTimes, id: \.self) { time in
                                        let mealsAtTime = mealsForDay.filter { Calendar.current.dateComponents([.hour, .minute], from: $0.intakeDate) == time }
                                        
                                        Section(header: Text(String(format: "%02d:%02d", time.hour ?? 0, time.minute ?? 0))
                                            .font(.headline)) {
                                                
                                                ForEach(mealsAtTime) { meal in
                                                    MealCardView(meal: meal, onDelete: {
                                                        mealToDelete = meal
                                                        showAlert = true
                                                    })
                                                }
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
            .navigationBarItems(leading: CustomBackButton(), trailing: HStack {
                CustomAddButton(action: {
                    showingAddMealSheet.toggle()
                })
                MealDocumentationButton()
                    .environmentObject(userViewModel)
            })
            .sheet(isPresented: $showingAddMealSheet) {
                NavigationStack {
                    AddMealSheetView(mealViewModel: viewModel, selectedDate: $selectedDate, selectedTime: $selectedTime)
                }
                .environmentObject(userViewModel)
            }
            .alert(isPresented: $showAlert) {
                if let mealToDelete = mealToDelete {
                    return Alert(
                        title: Text("Löschen bestätigen"),
                        message: Text("Möchten Sie diese Mahlzeit wirklich löschen?"),
                        primaryButton: .destructive(Text("Löschen")) {
                            if let userId = userViewModel.userId {
                                viewModel.deleteMeal(mealToDelete, userId: userId)
                            }
                        },
                        secondaryButton: .cancel(Text("Abbrechen"))
                    )
                } else {
                    return Alert(title: Text("Fehler"), message: Text("Es gibt keine Mahlzeit zum Löschen."), dismissButton: .default(Text("OK")))
                }
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


