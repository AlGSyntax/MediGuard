//
//  CityResponse.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 15.07.24.
//
import Foundation

// MARK: - CityResponse

/**
 Das `CityResponse`-Strukturmodell repräsentiert die Antwort der API, die eine Liste von Städten enthält.
 
 Diese Struktur implementiert das `Codable`-Protokoll, um eine einfache Kodierung und Dekodierung der JSON-Antworten der API zu ermöglichen.
 
 - Eigenschaften:
    - `localities`: Ein Array von `City`-Objekten, die die Städte repräsentieren.
 */
struct CityResponse: Codable {
    /// Ein Array von Städten, die von der API zurückgegeben werden.
    let localities: [City]
}

// MARK: - City

/**
 Das `City`-Strukturmodell repräsentiert eine Stadt mit einem Namen.
 
 Diese Struktur implementiert das `Codable`-Protokoll, um eine einfache Kodierung und Dekodierung zu ermöglichen.
 
 - Eigenschaften:
    - `name`: Der Name der Stadt.
 */
struct City: Codable {
    /// Der Name der Stadt.
    let name: String
}

