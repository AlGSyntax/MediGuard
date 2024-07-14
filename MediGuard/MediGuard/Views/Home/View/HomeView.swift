//
//  HomeView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

/**
 Die `HomeView`-Struktur ist eine SwiftUI-View, die den Hauptbildschirm der App darstellt.
 
 Diese View wird angezeigt, wenn der Benutzer erfolgreich authentifiziert ist und bietet Navigation zu verschiedenen Detailansichten sowie eine Notruffunktion.
 
 - Eigenschaften:
    - `homeViewModel`: Das `HomeViewModel`-Objekt, das die Daten und Logik für die `HomeView` verwaltet.
    - `settingsViewModel`: Das `SettingsViewModel`-Objekt, das die Daten und Logik für die Einstellungen verwaltet.
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Benutzerdaten verwaltet.
    - `isNavigatingToMedications`: Ein Bool-Wert, der den Navigationszustand zur Medikation verwaltet.
    - `isNavigatingToMeals`: Ein Bool-Wert, der den Navigationszustand zu den Mahlzeiten verwaltet.
    - `isNavigatingToDrinks`: Ein Bool-Wert, der den Navigationszustand zu den Getränken verwaltet.
 */
struct HomeView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var isNavigating = false // Zustand für die Navigation
    @State private var isNavigatingToMedications = false // Zustand für die Navigation
    @State private var isNavigatingToMeals = false // Zustand für die Navigation
    @State private var isNavigatingToDrinks = false // Zustand für die Navigation
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Begrüßung je nach Tageszeit
                
                Text(homeViewModel.greeting)
                    .hugeTitleStyle()// Verwendet den benutzerdefinierten Modifier für große Titel
                
                // MARK: - Name des aktuellen Benutzers
                
                Text("\(userViewModel.nameDisplay)!")
                    .hugeTitleStyle()// Verwendet den benutzerdefinierten Modifier für große Titel
                
                Spacer()
                
                // MARK: - Navigation Links
                
                VStack(spacing: 8) {
                    // NavigationLink zur Medikamentenverwaltung
                    AdministrationViewButton(title: "Medikamente", iconName: "pills.fill")
                        .animatedButton(isNavigating: $isNavigatingToMedications) {
                            isNavigatingToMedications = true
                        }
                    
                    // NavigationLink zur Mahlzeitenverwaltung
                    AdministrationViewButton(title: "Mahlzeiten", iconName: "fork.knife")
                        .animatedButton(isNavigating: $isNavigatingToMeals) {
                            isNavigatingToMeals = true
                        }
                    
                    // NavigationLink zur Getränkeverwaltung
                    AdministrationViewButton(title: "Getränke", iconName: "cup.and.saucer.fill")
                        .animatedButton(isNavigating: $isNavigatingToDrinks) {
                            isNavigatingToDrinks = true
                        }
                }
                .padding()
                
                // MARK: - Notruf Button
                
                EmergencyCallButton.callButton(homeViewModel: homeViewModel)// EmergencyCallButton zum Auslösen eines Notrufs bzw. der für den Notruf hinterlegten Nummer
                
                
                Spacer()
            }
            .padding()
            .background(Color("Background")) // Hier wird der Hintergrund gesetzt
            .onAppear {
                homeViewModel.updateGreeting()// Aktualisiert die Begrüßungsnachricht, wenn die View erscheint
            }
            .navigationDestination(isPresented: $isNavigatingToMedications) {
                            MedicationAdiminstrationView() // Zielansicht für Medikation
                        }
                        .navigationDestination(isPresented: $isNavigatingToMeals) {
                            MealAdministrationView() // Zielansicht für Mahlzeiten
                        }
                        .navigationDestination(isPresented: $isNavigatingToDrinks) {
                            DrinksAdministrationView() // Zielansicht für Getränke
                        }
            .navigationBarItems(trailing:
                                    NavigationLink(destination: SettingsView()) {
                SettingsButton()// Zeigt einen Button in der Navigation Bar an, um zu den Einstellungen zu navigieren
            }
            )
        }
        
        .environmentObject(homeViewModel)
        .environmentObject(settingsViewModel)
    }
}

// MARK: - Vorschau

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserViewModel())
            .environmentObject(HomeViewModel())
            .environmentObject(SettingsViewModel())
    }
}







