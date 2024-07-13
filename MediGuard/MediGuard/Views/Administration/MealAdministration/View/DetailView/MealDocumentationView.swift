//
//  MealDocumentationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import SwiftUI

/**
 Die Ansicht zur Anzeige der Mahlzeitenchronik.
 
 Diese Ansicht zeigt eine Liste von Mahlzeiten für die aktuelle Woche und vergangene Wochen an. Der Benutzer kann Mahlzeiten einsehen und löschen.
 Die Daten werden über das `MealDocumentationViewModel` und das `MealAdministrationViewModel` verwaltet.

 - Properties:
    - viewModel: Das ViewModel zur Verwaltung der Mahlzeitenchronik.
    - mealAdminViewModel: Das ViewModel zur Verwaltung von Mahlzeiten, die gelöscht werden können.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - expandedSections: Ein Zustand zur Verfolgung der erweiterten Abschnitte.
    - mealToDelete: Die Mahlzeit, die gelöscht werden soll.
    - showAlert: Ein Zustand zur Steuerung der Anzeige des Lösch-Alerts.
 */
struct MealDocumentationView: View {
    /// Das ViewModel zur Verwaltung der Mahlzeitenchronik.
    @StateObject private var viewModel = MealDocumentationViewModel()
    
    /// Das ViewModel zur Verwaltung von Mahlzeiten, die gelöscht werden können.
    @ObservedObject private var mealAdminViewModel = MealAdministrationViewModel()
    
    /// Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    @EnvironmentObject private var userViewModel: UserViewModel
    
    /// Ein Zustand zur Verfolgung der erweiterten Abschnitte.
    @State private var expandedSections: [String: Bool] = [:]
    
    /// Die Mahlzeit, die gelöscht werden soll.
    @State private var mealToDelete: Meal? = nil
    
    /// Zustand zur Steuerung der Anzeige des Lösch-Alerts.
    @State private var showAlert = false

    var body: some View {
        VStack {
            Text("Mahlzeiten Chronik")
                .font(.largeTitle)
                .padding()

            List {
                // Zeigt die aktuelle Woche an
                if let currentWeek = viewModel.currentWeek {
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["currentWeek"] ?? true },
                        set: { self.expandedSections["currentWeek"] = $0 }
                    )) {
                        // Gruppierung der Mahlzeiten der aktuellen Woche nach Tag
                        let groupedByDay = viewModel.groupMealsByDay(currentWeek.meals)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let meals = groupedByDay[day] ?? []
                            Section(header: Text(day)) {
                                // Gruppierung der Mahlzeiten des Tages nach Zeit
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    Section(header: Text("Zeit: \(time)")) {
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                mealToDelete = meal
                                                showAlert = true
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Aktuelle Woche \(currentWeek.weekNumber)")
                            .font(.headline)
                            .padding(.vertical, 5)
                    }
                }

                // Zeigt die vergangenen Wochen an
                ForEach(viewModel.pastWeeks, id: \.id) { week in
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["week-\(String(describing: week.id))"] ?? false },
                        set: { self.expandedSections["week-\(String(describing: week.id))"] = $0 }
                    )) {
                        // Gruppierung der Mahlzeiten der vergangenen Woche nach Tag
                        let groupedByDay = viewModel.groupMealsByDay(week.meals)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let meals = groupedByDay[day] ?? []
                            Section(header: Text(day)) {
                                // Gruppierung der Mahlzeiten des Tages nach Zeit
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    Section(header: Text("Zeit: \(time)")) {
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                mealToDelete = meal
                                                showAlert = true
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Woche  \(week.weekNumber)")
                            .font(.headline)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            if let mealToDelete = mealToDelete {
                return Alert(
                    title: Text("Löschen bestätigen"),
                    message: Text("Möchten Sie diese Mahlzeit wirklich löschen?"),
                    primaryButton: .destructive(Text("Löschen")) {
                        if let userId = userViewModel.userId {
                            mealAdminViewModel.deleteMeal(mealToDelete, userId: userId)
                        }
                    },
                    secondaryButton: .cancel(Text("Abbrechen"))
                )
            } else {
                return Alert(title: Text("Fehler"), message: Text("Es gibt keine Mahlzeit zum Löschen."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            // Lädt die Daten, wenn die Ansicht angezeigt wird
            if let userId = userViewModel.userId {
                viewModel.fetchCurrentWeek(userId: userId)
                viewModel.fetchPastWeeks(userId: userId)
            }
        }
    }
}

// Vorschau der MealDocumentationView
struct MealDocumentationView_Previews: PreviewProvider {
    static var previews: some View {
        MealDocumentationView()
            .environmentObject(UserViewModel())
    }
}










