//
//  DrinksDocumentationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.07.24.
//

import SwiftUI

struct DrinksDocumentationView: View {
    @StateObject private var viewModel = DrinksDocumentationViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var expandedSections: [String: Bool] = [:]
    
    var body: some View {
        VStack {
            Text("Getränke Chronik")
                .font(.largeTitle)
                .padding()

            List {
                // Zeigt die aktuelle Woche an
                if let currentWeek = viewModel.currentWeek {
                    DisclosureGroup(isExpanded: Binding(
                        get: { self.expandedSections["currentWeek"] ?? true },
                        set: { self.expandedSections["currentWeek"] = $0 }
                    )) {
                        // Gruppierung der Getränke der aktuellen Woche nach Tag
                        let groupedByDay = viewModel.groupIntakesByDay(currentWeek.intakes)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let intakes = groupedByDay[day] ?? []
                            let totalIntake = intakes.reduce(0) { $0 + $1.amount }
                            Section(header: Text(day)
                                .background(totalIntake >= viewModel.goal ? Color.blue : Color.red)
                                .cornerRadius(8)
                                .foregroundStyle(.white)) {
                                Text("Gesamt: \(totalIntake) mL")
                                    .font(.headline)
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
                        // Gruppierung der Getränke der vergangenen Woche nach Tag
                        let groupedByDay = viewModel.groupIntakesByDay(week.intakes)
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            let intakes = groupedByDay[day] ?? []
                            let totalIntake = intakes.reduce(0) { $0 + $1.amount }
                            Section(header: Text(day)
                                .background(totalIntake >= viewModel.goal ? Color.blue : Color.red)
                                .cornerRadius(8)
                                .foregroundStyle(.white)) {
                                Text("Gesamt: \(totalIntake) mL")
                                    .font(.headline)
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchCurrentWeek(userId: userId)
                viewModel.fetchPastWeeks(userId: userId)
            }
            
        }
    }
}

// Vorschau der DrinksDocumentationView
struct DrinksDocumentationView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksDocumentationView()
            .environmentObject(UserViewModel())
    }
}

