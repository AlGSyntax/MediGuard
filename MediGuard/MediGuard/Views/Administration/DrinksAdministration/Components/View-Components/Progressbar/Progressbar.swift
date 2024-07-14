//
//  Progressbar.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

/**
 Die `ProgressBar`-Struktur ist eine benutzerdefinierte SwiftUI-View, die eine kreisförmige Fortschrittsanzeige darstellt.
 
 Diese Ansicht zeigt den Fortschritt als Prozentsatz, eine Beschreibung des täglichen Ziels und die aktuelle und Zielmenge in Millilitern an.
 
 - Parameter:
    - progress: Ein Float-Wert, der den aktuellen Fortschritt darstellt (zwischen 0 und 1).
    - goal: Ein Integer-Wert, der das tägliche Ziel in Millilitern darstellt.
    - intakeAmount: Ein Integer-Wert, der die bisherige Aufnahme in Millilitern darstellt.
 */
struct ProgressBar: View {
    var progress: Float
    var goal: Int
    var intakeAmount: Int

    var body: some View {
        ZStack {
            // Vertikaler Stapel für den Text und das Symbol
            VStack {
                // Horizontaler Stapel für den Prozentwert und das Symbol
                HStack {
                    // Prozentwertanzeige
                    Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                        .foregroundStyle(.blue)
                        .font(Fonts.largeTitle)
                    
                    // Tropfensymbol
                    Image(systemName: "drop.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                }
                .padding()

                // Beschreibung des täglichen Ziels
                Text("Ihres täglichen Ziels")
                    .headlineBlue()
                    .padding()

                // Anzeige der aktuellen und Zielmenge
                Text("\(intakeAmount) mL / \(goal) mL")
                    .headlineBlue()
                    .padding()
            }
            
            // Äußerer Kreis für die Fortschrittsanzeige
            Circle()
                .stroke(lineWidth: 13) // Strichbreite des äußeren Kreises
                .opacity(0.3) // Transparenz des äußeren Kreises
                .foregroundStyle(.blue) // Farbe des äußeren Kreises
                .frame(width: 250, height: 250) // Größe des äußeren Kreises
            
            // Fortschrittskreis
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0))) // Fortschritt basierend auf dem `progress`-Wert
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)) // Stil des Fortschrittskreises
                .foregroundStyle(.blue) // Farbe des Fortschrittskreises
                .rotationEffect(Angle(degrees: 270.0)) // Startwinkel des Fortschrittskreises
                .animation(.easeOut(duration: 0.25), value: progress) // Animation des Fortschritts
                .frame(width: 250, height: 250) // Größe des Fortschrittskreises
        }
        .frame(width: 300, height: 300) // Gesamtrahmen der ProgressBar
    }
}

// Vorschau der `ProgressBar`-Struktur
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.9, goal: 3000, intakeAmount: 2500)
    }
}

