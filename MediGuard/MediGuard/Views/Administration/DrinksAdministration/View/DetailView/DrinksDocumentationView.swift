//
//  DrinksDocumentationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.07.24.
//

import SwiftUI

// MARK: - DrinksDocumentationView

/**
 Die Hauptansicht zur Verwaltung und Anzeige des Getränkekonsums.

 Diese Ansicht zeigt eine Liste von Getränken für die aktuelle und vergangene Wochen an. Der Benutzer kann den Gesamtverbrauch sehen und ob das Tagesziel erreicht wurde.
 
 - Properties:
    - viewModel: Das ViewModel zur Verwaltung der Getränkeverläufe.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - expandedSections: Ein Zustand zur Verfolgung der erweiterten Abschnitte.
 */

struct DrinksDocumentationView: View {
    
    // MARK: - Properties
       
    /// Das ViewModel zur Verwaltung der Getränkeverläufe.
    @StateObject private var viewModel = DrinksDocumentationViewModel()
    
    /// Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    @EnvironmentObject private var userViewModel: UserViewModel
    
    /// Ein Zustand zur Verfolgung der erweiterten Abschnitte.
    @State private var expandedSections: [String: Bool] = [:]
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("Verlauf")
                .hugeTitleStyle()

            List {
                
                // MARK: - Aktuelle Woche
                
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
                                .font(Fonts.title1)// Setzt die Schriftart
                                                             .padding(.vertical, 10)
                                                             .padding(.horizontal, 10)
                                                             .background(Color.blue)// Hintergrundfarbe des Headers
                                                             .foregroundStyle(.white)// Schriftfarbe des Headers
                                                             .cornerRadius(8)// Abrundung des Headers
                                                             .shadow(color: .mint, radius: 1, x: 0, y: 7)// Schatten des Headers
                            ) {
                                Text("Gesamt: \(totalIntake) mL")
                                    .headlineBlue()
                                Text(totalIntake >= viewModel.goal ? "Tagesziel erreicht" : "Tagesziel noch nicht erreicht")
                                                                    .bodyBlue()
                            }
                        }
                    } label: {
                        Text("Aktuelle Woche \(currentWeek.weekNumber)")
                            .headlineBlue()
                    }
                    .listRowBackground(Color("Background"))
                }
                
                // MARK: - Vergangene Wochen

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
                                .font(Fonts.title1)// Setzt die Schriftart
                                                             .padding(.vertical, 10)
                                                             .padding(.horizontal, 10)
                                                             .background(Color.blue)// Hintergrundfarbe des Headers
                                                             .foregroundStyle(.white)// Schriftfarbe des Headers
                                                             .cornerRadius(8)// Abrundung des Headers
                                                             .shadow(color: .mint, radius: 1, x: 0, y: 7)
                            ) {
                                Text("Gesamt: \(totalIntake) mL")
                                    .headlineBlue()
                                Text(totalIntake >= viewModel.goal ? "Tagesziel erreicht" : "Tagesziel nicht erreicht")
                                                                    .bodyBlue()
                            }
                        }
                    } label: {
                        Text("Woche \(week.weekNumber)")
                            .headlineBlue()
                    }
                    .listRowBackground(Color("Background"))
                }
            }
            .listStyle(PlainListStyle()) // Setzt den Listenstil
            .background(Color("Background")) // Hintergrund für die Liste
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchCurrentWeek(userId: userId)
                viewModel.fetchPastWeeks(userId: userId)
            }
            
        }
        .background(Color("Background").ignoresSafeArea()) //
    }
}

// Vorschau der DrinksDocumentationView
struct DrinksDocumentationView_Previews: PreviewProvider {
    static var previews: some View {
        DrinksDocumentationView()
            .environmentObject(UserViewModel())
    }
}

