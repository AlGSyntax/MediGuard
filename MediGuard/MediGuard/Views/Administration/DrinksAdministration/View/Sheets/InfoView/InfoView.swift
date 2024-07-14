//
//  InfoView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

// MARK: - InfoView

/**
 Eine Ansicht, die Informationen zur täglichen Flüssigkeitszufuhr anzeigt.

 Diese Ansicht zeigt eine ScrollView mit Texten und Symbolen, die den täglichen Flüssigkeitsbedarf für Männer und Frauen beschreiben. Außerdem werden Faktoren berücksichtigt, die den Flüssigkeitsbedarf beeinflussen können.
 
 - Properties:
    - dismiss: Die Umgebungsvariable zum Schließen der Ansicht.
 */
struct InfoView: View {
    // MARK: - Properties
    
    /// Die Umgebungsvariable zum Schließen der Ansicht
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    // Symbol für Wasser
                    Image(systemName: "drop")
                        .symbolVariant(.fill)
                        .foregroundStyle(.blue)
                        .font(.system(size: 80))
                    
                    // Symbol für Lineal
                    Image(systemName: "ruler")
                        .foregroundStyle(.blue)
                        .font(.system(size: 60))
                }
                .padding()
                
                // Text zur Erklärung der täglichen Wasserverluste und des Bedarfs
                Text("Jeden Tag verlieren wir Wasser durch unsere Atmung, Schweiß, Urin und Stuhlgang. Damit unser Körper richtig funktioniert, müssen wir seinen Wasservorrat durch den Verzehr von wasserhaltigen Getränken und Lebensmitteln wieder auffüllen. Eine angemessene tägliche Flüssigkeitszufuhr ist ungefähr:")
                    .bodyBlue()
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                    
                
                Spacer()
                
                VStack(alignment: .leading) {
                    // Text für den Flüssigkeitsbedarf von Männern
                    Text("Männer - 15,5 Tassen (3,7 l) Flüssigkeit täglich")
                        .headlineBlue()
                    
                   
                    
                    // Text für den Flüssigkeitsbedarf von Frauen
                    Text("Frauen - 11,5 Tassen (2,7 l) Flüssigkeit täglich")
                        .headlineBlue()
                }
                .padding()
               
                Spacer()
                
                HStack(alignment: .center, spacing: 50) {
                    // Symbol für Bewegung
                    Image(systemName: "figure.walk")
                        .foregroundStyle(.orange)
                        .font(.system(size: 50))
                    
                    // Symbol für Wetter
                    Image(systemName: "cloud.sun")
                        .symbolVariant(.fill)
                        .foregroundStyle(.green)
                        .font(.system(size: 40))
                    
                    // Symbol für Gesundheit
                    Image(systemName: "cross.circle")
                        .symbolVariant(.fill)
                        .foregroundColor(.red)
                        .font(.system(size: 40))
                }
                .padding()
                
                // Text zur Erklärung der Anpassung der Flüssigkeitszufuhr
                Text("Die gesamte Flüssigkeitszufuhr muss je nach Trainingsintensität, Umgebung (d. h. heißes/feuchtes Wetter erhöht die Schweißproduktion) und allgemeinem Gesundheitszustand angepasst werden.")
                    .bodyBlue()
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                // Quelle
                Text("Quelle: Mayo Clinic")
                    .font(Fonts.footnote)
            }
        }
        .background(Color("Background").ignoresSafeArea()) // Setzt den Hintergrund für die gesamte Ansicht
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Button zum Schließen der Ansicht
                Button("Schließen") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Informationen")
    }
}

// MARK: - Preview

/**
 Vorschau der `InfoView`-Struktur.

 Diese Vorschau zeigt die `InfoView` in Xcode's SwiftUI Preview an.
 */
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InfoView()
        }
    }
}

