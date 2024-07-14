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
                            .hugeTitleStyle()
                        
                    }
                }
                .padding(.top, 20)
                
                // MARK: - Mahlzeitenliste
                
                List {
                    // Iteriert über die Tage der aktuellen Woche
                    ForEach(viewModel.currentWeek(), id: \.self) { date in
                        // Überprüft, ob das Datum in der aktuellen Woche liegt und nicht in der Vergangenheit liegt
                        if viewModel.isInCurrentWeek(date) && !viewModel.isInPast(date) {
                            // Erstellt eine Section für jeden Tag der Woche
                            Section(header: HStack {
                                Spacer()
                                let dayString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
                                Text(dayString)
                                    .font(Fonts.title1)// Setzt die Schriftart
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.blue)// Hintergrundfarbe des Headers
                                    .foregroundStyle(.white)// Schriftfarbe des Headers
                                    .cornerRadius(8)// Abrundung des Headers
                                    .shadow(color: .mint, radius: 1, x: 0, y: 7)// Schatten des Headers
                                Spacer()
                            }) {
                                // Filtert die Mahlzeiten für den aktuellen Tag
                                let mealsForDay = viewModel.meals.filter { meal in
                                    let mealDate = Calendar.current.startOfDay(for: meal.intakeDate)
                                    return mealDate == date
                                }
                                
                                // Extrahiert die einzigartigen Uhrzeiten der Mahlzeiten für den Tag
                                let uniqueTimes = Set(mealsForDay.map { Calendar.current.dateComponents([.hour, .minute], from: $0.intakeDate) })
                                // Sortiert die Uhrzeiten
                                let sortedTimes = Array(uniqueTimes).sorted {
                                    ($0.hour ?? 0) < ($1.hour ?? 0) || (($0.hour ?? 0) == ($1.hour ?? 0) && ($0.minute ?? 0) < ($1.minute ?? 0))
                                }
                                
                                // Überprüft, ob es Mahlzeiten für den Tag gibt
                                if mealsForDay.isEmpty {
                                    Text("Noch keine Mahlzeiten hinterlegt")
                                        .foregroundStyle(.black)
                                        .font(Fonts.headline)
                                        .listRowBackground(Color("Background"))
                                } else {
                                    // Iteriert über die sortierten Uhrzeiten
                                    ForEach(sortedTimes, id: \.self) { time in
                                        // Filtert die Mahlzeiten für die aktuelle Uhrzeit
                                        let mealsAtTime = mealsForDay.filter { Calendar.current.dateComponents([.hour, .minute], from: $0.intakeDate) == time }
                                        
                                        
                                        // Erstellt eine Section für jede Uhrzeit
                                        Section(header: Text(String(format: "%02d:%02d", time.hour ?? 0, time.minute ?? 0))
                                            .font(Fonts.largeTitle)
                                            .frame(minHeight: 50)
                                            .background(Color.white)
                                            .foregroundStyle(.blue)
                                            .cornerRadius(8)
                                            
                                            ) {
                                                // Iteriert über die Mahlzeiten für die aktuelle Uhrzeit
                                                ForEach(mealsAtTime) { meal in
                                                    MealCardView(meal: meal, onDelete: {
                                                        mealToDelete = meal
                                                        showAlert = true
                                                    })
                                                    .listRowBackground(Color("Background"))
                                                    .cornerRadius(20)// Abrundung der Kartenansicht
                                                }
                                                
                                                .listRowBackground(Color("Background"))
                                            }
                                        
                                            .background(Color("Background"))
                                            .listRowInsets(EdgeInsets())
                                    }
                                    
                                }
                                    
                            }
                            .background(Color("Background"))
                        }
                    }
                    .listRowBackground(Color("Background"))
                }
                .listStyle(PlainListStyle())
                .background(Color("Background"))
                .cornerRadius(32)
            }
            .padding(.horizontal)
            .background(Color("Background"))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton(), trailing: HStack {
                CustomAddButton(action: {
                    showingAddMealSheet.toggle()
                })
                MealDocumentationButton()
                    .environmentObject(userViewModel)
            })
            // Zeigt das Add Meal Sheet an
            .sheet(isPresented: $showingAddMealSheet) {
                NavigationStack {
                    AddMealSheetView(mealViewModel: viewModel, selectedDate: $selectedDate, selectedTime: $selectedTime)
                }
                .environmentObject(userViewModel)
            }
            // Alert zur Bestätigung des Löschens einer Mahlzeit
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
                        secondaryButton: .cancel(Text("Abbrechen").bodyBlue())
                    )
                } else {
                    return Alert(title: Text("Fehler").bodyBlue(), message: Text("Es gibt keine Mahlzeit zum Löschen.").bodyBlue(), dismissButton: .default(Text("OK")))
                }
            }
            // Lädt die Mahlzeiten beim Erscheinen der Ansicht
            .onAppear {
                if let userId = userViewModel.userId {
                    viewModel.fetchMeals(userId: userId)
                }
            }
        }
        .background(Color("Background").ignoresSafeArea()) // Setzt den Hintergrund für die gesamte NavigationStack
    }
}

// MARK: - Previews

struct MealAdministrationView_Previews: PreviewProvider {
    static var previews: some View {
        MealAdministrationView()
            .environmentObject(UserViewModel())
    }
}


