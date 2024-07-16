//
//  NameViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 15.07.24.
//

import Foundation
import Combine

// MARK: - CityViewModel

/**
 Das `CityViewModel`-Klassenmodell verwaltet den Zustand und die Logik für die Suche nach Städten.
 
 Diese Klasse implementiert das `ObservableObject`-Protokoll, um Änderungen des Zustands an die SwiftUI-Views zu binden.
 
 - Eigenschaften:
 - `cities`: Ein Array von `City`-Objekten, die die gefundenen Städte repräsentieren.
 - `errorMessage`: Eine optionale Zeichenkette, die eine Fehlermeldung enthält, falls ein Fehler auftritt.
 - `searchText`: Eine Zeichenkette, die den aktuellen Text im Suchfeld enthält.
 
 - Methoden:
 - `searchCities(byName:)`: Führt eine Suche nach Städten anhand eines Namens durch.
 - `clearSearchText()`: Leert den Text im Suchfeld.
 */
@MainActor
class CityViewModel: ObservableObject {
    
    /// Ein Array von Städten, die durch die Suche gefunden wurden.
    @Published var cities: [City] = []
    
    /// Eine optionale Fehlermeldung, die angezeigt wird, wenn ein Fehler auftritt.
    @Published var errorMessage: String?
    
    /// Der aktuelle Text im Suchfeld.
    @Published var searchText = ""
    
    /// Eine Instanz des `CityRepository`, das die Logik zum Abrufen der Städte enthält.
    private let repository = CityRepository()
    
    
    /**
     Sucht nach Städten anhand eines Namens.
     
     Diese Methode führt eine asynchrone Suche durch, indem sie das `CityRepository` verwendet,
     um die Städte abzurufen und das Ergebnis im `cities`-Array zu speichern.
     
     - Parameter name: Der Name der Stadt, nach der gesucht werden soll.
     */
    func searchCities(byName name: String) {
        
        // Ausgabe des Suchnamens zur Fehlersuche.
        print("Searching for cities with name: \(name)")
        
        // Startet eine asynchrone Aufgabe zur Suche nach Städten.
        Task {
            do {
                // Ruft die Städte vom Repository ab.
                let cities = try await repository.fetchCities(byName: name)
                
                // Ausgabe der gefundenen Städte zur Fehlersuche.
                print("Fetched cities: \(cities.map { $0.name })")
                
                // Aktualisiert das `cities`-Array mit den gefundenen Städten.
                self.cities = cities
                
                // Zusätzliche Ausgabe der Städte.
                print(cities)
            } catch {
                self.errorMessage = "Fehler beim Abrufen der Städte: \(error.localizedDescription)"
                print("Error fetching cities: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     Leert den Text im Suchfeld.
     
     Diese Methode setzt die `searchText`-Eigenschaft auf einen leeren String, um das Suchfeld zu leeren.
     */
    func clearSearchText() {
        searchText = ""
    }
}



