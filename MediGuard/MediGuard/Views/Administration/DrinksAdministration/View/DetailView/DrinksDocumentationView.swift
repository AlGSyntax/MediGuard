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
                
                // Überprüft, ob `currentWeek` im `viewModel` vorhanden ist.
                if let currentWeek = viewModel.currentWeek {
                    // Erstellt eine DisclosureGroup, die eine ausklappbare Ansicht darstellt.
                    DisclosureGroup(isExpanded: Binding(
                        // Ruft den aktuellen Erweiterungszustand ab oder setzt ihn auf `true`, wenn nicht vorhanden.
                        get: { self.expandedSections["currentWeek"] ?? true },
                        // Aktualisiert den Erweiterungszustand im Dictionary.
                        set: { self.expandedSections["currentWeek"] = $0 }
                    )) {
                        // Gruppiert die Getränkezunahmen der aktuellen Woche nach Tag.
                        let groupedByDay = viewModel.groupIntakesByDay(currentWeek.intakes)
                        // Iteriert über die gruppierten Tage.
                        ForEach(groupedByDay.keys.sorted(), id: \.self) { day in
                            // Ruft die Getränkezunahmen für den Tag ab oder setzt sie auf eine leere Liste.
                            let intakes = groupedByDay[day] ?? []
                            // Berechnet die gesamte Getränkemenge für den Tag.
                            let totalIntake = intakes.reduce(0) { $0 + $1.amount }
                            // Erstellt eine Sektion für jeden Tag.
                            Section(header: Text(day)
                                    // Definiert den Header der Sektion mit dem Tagesnamen und wendet den benutzerdefinierten Stil an.
                                .customHeaderStyle()
                            ) {
                                // Zeigt die gesamte Getränkemenge für den Tag an.
                                Text("Gesamt: \(totalIntake) mL")
                                    .headlineBlue()
                                
                                // Zeigt an, ob das Tagesziel erreicht wurde, und wendet den Stil für den Textkörper an.
                                Text(totalIntake >= viewModel.goal ? "Tagesziel erreicht" : "Tagesziel noch nicht erreicht")
                                    .foregroundStyle(totalIntake >= viewModel.goal ? .blue : .red)
                            }
                        }
                    } label: {
                        // Definiert das Label der DisclosureGroup mit dem Wochenbezeichner und wendet den Stil für die Schlagzeile an.
                        Text("Aktuelle Woche \(currentWeek.weekNumber)")
                            .headlineBlue()
                    }
                    // Setzt den Hintergrund der Listenzeile auf eine benutzerdefinierte Farbe.
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
                                .customHeaderStyle()
                            ) {
                                Text("Gesamt: \(totalIntake) mL")
                                    .headlineBlue()
                                Text(totalIntake >= viewModel.goal ? "Tagesziel erreicht" : "Tagesziel nicht erreicht")
                                    .foregroundStyle(totalIntake >= viewModel.goal ? .blue : .red)
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

