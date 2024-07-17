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
            Text("Verlauf")
                .hugeTitleStyle()

            List {
                // Überprüft, ob `currentWeek` im `viewModel` vorhanden ist.
                if let currentWeek = viewModel.currentWeek {
                    // Erstellt eine DisclosureGroup, die eine ausklappbare Ansicht darstellt.
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["currentWeek"] ?? true },
                        set: { self.expandedSections["currentWeek"] = $0 }
                    )) {
                        // Gruppiert die Mahlzeiten der aktuellen Woche nach Tag.
                        let groupedByDay = viewModel.groupMealsByDay(currentWeek.meals)
                        // Iteriert über die gruppierten Tage.
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            // Ruft die Mahlzeiten für den Tag ab oder setzt sie auf eine leere Liste.
                            let meals = groupedByDay[day] ?? []
                            // Erstellt eine Sektion für jeden Tag.
                            Section(header: Text(day)
                                    // Definiert den Header der Sektion mit dem Tagesnamen und wendet den benutzerdefinierten Stil an.
                                .customHeaderStyle()
                            ) {
                                // Gruppierung der Mahlzeiten des Tages nach Zeit
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                // Iteriert über die gruppierten Zeiten.
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    // Erstellt eine Sektion für jede Zeit.
                                    Section(header: Text("Zeit: \(time)")
                                        .bodyBlue()) {
                                            // Iteriert über die Mahlzeiten zu einer bestimmten Zeit.
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                // Setzt die zu löschende Mahlzeit und zeigt das Lösch-Alert an.
                                                mealToDelete = meal
                                                showAlert = true
                                            })
                                            .listRowBackground(Color("Background"))
                                        }
                                    }
                                    .listRowBackground(Color("Background"))
                                }
                            }
                            .listRowBackground(Color("Background"))
                        }
                    } label: {
                        Text("Aktuelle Woche \(currentWeek.weekNumber)")
                            .headlineBlue()
                    }
                    .listRowBackground(Color("Background"))
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
                            Section(header: Text(day)
                                .customHeaderStyle()
                            ) {
                                // Gruppierung der Mahlzeiten des Tages nach Zeit
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    Section(header: Text("Zeit: \(time)")
                                        .bodyBlue()) {
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                mealToDelete = meal
                                                showAlert = true
                                            })
                                            .listRowBackground(Color("Background"))
                                        }
                                    }
                                    .listRowBackground(Color("Background"))
                                }
                            }
                            .listRowBackground(Color("Background"))
                        }
                    } label: {
                        Text("Woche  \(week.weekNumber)")
                            .headlineBlue()
                    }
                    .listRowBackground(Color("Background"))
                }
            }
            .listStyle(PlainListStyle())
            .background(Color("Background"))
            .cornerRadius(32)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .padding(.horizontal)
        .background(Color("Background").ignoresSafeArea())
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
                return Alert(title: Text("Fehler").bodyBlue(), message: Text("Es gibt keine Mahlzeit zum Löschen.").bodyBlue(), dismissButton: .default(Text("OK").bodyBlue()))
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










