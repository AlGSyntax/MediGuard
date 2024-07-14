//
//  Fonts.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 18.06.24.
//

import SwiftUI

/**
 Die `Fonts`-Struktur enthält benutzerdefinierte Schriftarten, die in der App verwendet werden.
 
 Diese Struktur stellt verschiedene Schriftarten in unterschiedlichen Größen bereit, um eine konsistente Typografie in der gesamten App zu gewährleisten. Alle Schriftarten basieren auf der "Ubuntu"-Schriftfamilie und verwenden verschiedene Stile wie Bold, Regular und LightItalic.

 - Eigenschaften:
    - hugeTitle: Eine große fette Schriftart, die für große Titel verwendet wird (40 Punkte).
    - largeTitle: Eine große fette Schriftart, die für große Überschriften verwendet wird (34 Punkte).
    - title2: Eine fette Schriftart, die für mittlere Überschriften verwendet wird (28 Punkte).
    - title1: Eine fette Schriftart, die für kleinere Überschriften verwendet wird (24 Punkte).
    - title3: Eine fette Schriftart, die für noch kleinere Überschriften verwendet wird (22 Punkte).
    - title: Eine fette Schriftart, die für allgemeine Titel verwendet wird (21 Punkte).
    - headline: Eine fette Schriftart, die für Überschriften und wichtige Texte verwendet wird (20 Punkte).
    - body: Eine reguläre Schriftart, die für den Hauptinhalt verwendet wird (24 Punkte).
    - callout: Eine reguläre Schriftart, die für Hervorhebungen im Text verwendet wird (16 Punkte).
    - subheadline: Eine mittlere Schriftart, die für Unterüberschriften verwendet wird (15 Punkte).
    - footnote: Eine leichte kursiv Schriftart, die für Fußnoten und ergänzende Informationen verwendet wird (13 Punkte).
    - caption2: Eine reguläre Schriftart, die für Beschriftungen und kleinere Texte verwendet wird (12 Punkte).
    - caption1: Eine leichte kursiv Schriftart, die für kleinere Beschriftungen und Hinweise verwendet wird (11 Punkte).
 */
struct Fonts {
    // MARK: - Title Fonts

    /// Eine große fette Schriftart für große Titel (40 Punkte).
    static let hugeTitle = Font.custom("Ubuntu-Bold", size: 40)
    
    /// Eine große fette Schriftart für große Überschriften (34 Punkte).
    static let largeTitle = Font.custom("Ubuntu-Bold", size: 34)
    
    /// Eine fette Schriftart für mittlere Überschriften (28 Punkte).
    static let title2 = Font.custom("Ubuntu-Bold", size: 28)
    
    /// Eine fette Schriftart für kleinere Überschriften (24 Punkte).
    static let title1 = Font.custom("Ubuntu-Bold", size: 24)
    
    /// Eine fette Schriftart für noch kleinere Überschriften (22 Punkte).
    static let title3 = Font.custom("Ubuntu-Bold", size: 22)
    
    /// Eine fette Schriftart für allgemeine Titel (21 Punkte).
    static let title = Font.custom("Ubuntu-Bold", size: 21)

    // MARK: - Text Fonts

    /// Eine fette Schriftart für Überschriften und wichtige Texte (20 Punkte).
    static let headline = Font.custom("Ubuntu-Bold", size: 20)
    
    /// Eine reguläre Schriftart für den Hauptinhalt (24 Punkte).
    static let body = Font.custom("Ubuntu-Regular", size: 24)
    
    /// Eine reguläre Schriftart für Hervorhebungen im Text (16 Punkte).
    static let callout = Font.custom("Ubuntu-Regular", size: 16)
    
    /// Eine mittlere Schriftart für Unterüberschriften (15 Punkte).
    static let subheadline = Font.custom("Ubuntu-Medium", size: 15)
    
    /// Eine leichte kursiv Schriftart für Fußnoten und ergänzende Informationen (13 Punkte).
    static let footnote = Font.custom("Ubuntu-LightItalic", size: 13)

    // MARK: - Caption Fonts

    /// Eine reguläre Schriftart für Beschriftungen und kleinere Texte (12 Punkte).
    static let caption2 = Font.custom("Ubuntu-Regular", size: 12)
    
    /// Eine leichte kursiv Schriftart für kleinere Beschriftungen und Hinweise (11 Punkte).
    static let caption1 = Font.custom("Ubuntu-LightItalic", size: 11)
}

