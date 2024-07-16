//
//  NameRepository.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 15.07.24.
//
import Foundation

// MARK: - CityRepository

/**
 Die `CityRepository`-Klasse bietet Funktionen zum Abrufen von Städten anhand ihres Namens von einer externen API.
 
 Diese Klasse verwendet asynchrone Funktionen (`async`), um HTTP-Anfragen zu stellen und die Ergebnisse zu verarbeiten.
 */
class CityRepository {
    
    /**
     Ruft Städte anhand ihres Namens von einer externen API ab.
     
     - Parameters:
     - name: Der Name der Stadt, nach der gesucht werden soll.
     - pageSize: Die Anzahl der Ergebnisse pro Seite (Standardwert ist 3).
     - page: Die Seite der Ergebnisse, die abgerufen werden soll (Standardwert ist 1).
     - Returns: Ein Array von `City`-Objekten, die den abgerufenen Städten entsprechen.
     - Throws: `HTTPError.invalidURL` bei einer ungültigen URL oder andere Fehler, die während der HTTP-Anfrage auftreten.
     */
    func fetchCities(byName name: String, pageSize: Int = 3, page: Int = 1) async throws -> [City] {
        
        // Die URL-Zeichenkette zur Abfrage der Städte-API, einschließlich des Namens, der Seitengröße und der Seite.
        let urlString = "https://openplzapi.org/de/Localities?name=\(name)&page=\(page)&pageSize=\(pageSize)"
        
        // Ausgabe der abgerufenen URL zur Fehlersuche.
        print("Fetching cities with URL: \(urlString)")
        
        // Versucht, die URL-Zeichenkette in ein `URL`-Objekt zu konvertieren.
        // Wenn die URL ungültig ist, wird ein `invalidURL`-Fehler geworfen.
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw HTTPError.invalidURL
        }
        
        // Führt eine HTTP-Anfrage durch und erhält die Daten.
        // Diese Zeile wartet asynchron auf die Antwort der HTTP-Anfrage.
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonString = String(data: data, encoding: .utf8)
        print("Received data: \(jsonString ?? "No data")")
        
        // Dekodiert die JSON-Daten in ein Array von `City`-Objekten.
        // Wenn die Dekodierung fehlschlägt, wird ein Fehler geworfen.
        let cityResponse = try JSONDecoder().decode([City].self, from: data)
        
        // Gibt das Array der abgerufenen Städte zurück.
        return cityResponse
    }
}



