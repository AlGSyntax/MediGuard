//
//  MealDocumentationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 05.07.24.
//

import SwiftUI

struct MealDocumentationView: View {
    @StateObject private var viewModel = MealDocumentationViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel

    // State to track expanded sections
    @State private var expandedSections: [String: Bool] = [:]

    var body: some View {
        VStack {
            Text("Mahlzeiten Chronik")
                .font(.largeTitle)
                .padding()

            List {
                if let currentWeek = viewModel.currentWeek {
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["currentWeek"] ?? true },
                        set: { self.expandedSections["currentWeek"] = $0 }
                    )) {
                        let groupedByDay = viewModel.groupMealsByDay(currentWeek.meals)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let meals = groupedByDay[day] ?? []
                            Section(header: Text(day)) {
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    Section(header: Text("Zeit: \(time)")) {
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                // Provide delete action if necessary
                                            }, onEdit: {
                                                // Provide edit action if necessary
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

                ForEach(viewModel.pastWeeks, id: \.id) { week in
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["week-\(String(describing: week.id))"] ?? false },
                        set: { self.expandedSections["week-\(String(describing: week.id))"] = $0 }
                    )) {
                        let groupedByDay = viewModel.groupMealsByDay(week.meals)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let meals = groupedByDay[day] ?? []
                            Section(header: Text(day)) {
                                let groupedByTime = viewModel.groupMealsByTime(meals)
                                ForEach(groupedByTime.keys.sorted(), id: \.self) { time in
                                    let mealsAtTime = groupedByTime[time] ?? []
                                    Section(header: Text("Zeit: \(time)")) {
                                        ForEach(mealsAtTime, id: \.id) { meal in
                                            MealCardView(meal: meal, onDelete: {
                                                // Provide delete action if necessary
                                            }, onEdit: {
                                                // Provide edit action if necessary
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Woche \(week.weekNumber)")
                            .font(.headline)
                            .padding(.vertical, 5)
                    }
                }
            }
        }
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchCurrentWeek(userId: userId)
                viewModel.fetchPastWeeks(userId: userId)
            }
        }
    }
}

struct MealDocumentationView_Previews: PreviewProvider {
    static var previews: some View {
        MealDocumentationView()
            .environmentObject(UserViewModel())
    }
}








