//
//  InfoView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    Image(systemName: "drop")
                        .symbolVariant(.fill)
                        .foregroundStyle(.blue)
                        .font(.system(size: 80))
                    
                    Image(systemName: "ruler")
                        .foregroundStyle(.blue)
                        .font(.system(size: 60))
                }
                .padding()
                
                Text("Jeden Tag verlieren wir Wasser durch unsere Atmung, Schweiß, Urin und Stuhlgang. Damit unser Körper richtig funktioniert, müssen wir seinen Wasservorrat durch den Verzehr von wasserhaltigen Getränken und Lebensmitteln wieder auffüllen. Eine angemessene tägliche Flüssigkeitszufuhr ist ungefähr:")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                
                
                VStack {
                    Text("Männer - 15,5 Tassen (3,7 l) Flüssigkeit täglich")
                        .bold()
                        
                    
                    Spacer()
                    
                    Text("Frauen - 11,5 Tassen (2,7 l) Flüssigkeit täglich")
                        .bold()
                        
                }
                .padding()
                
                
                HStack(alignment: .center, spacing: 50) {
                    Image(systemName: "figure.walk")
                        .foregroundStyle(.orange)
                        .font(.system(size: 50))
                    
                    Image(systemName: "cloud.sun")
                        .symbolVariant(.fill)
                        .foregroundStyle(.green)
                        .font(.system(size: 40))
                    
                    Image(systemName: "cross.circle")
                        .symbolVariant(.fill)
                        .foregroundColor(.red)
                        .font(.system(size: 40))
                }
                .padding()
                
                Text("Die gesamte Flüssigkeitszufuhr muss je nach Trainingsintensität, Umgebung (d. h. heißes/feuchtes Wetter erhöht die Schweißproduktion) und allgemeinem Gesundheitszustand angepasst werden.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                Text("Quelle: Mayo Clinic")
                    .font(.caption)
                    .bold()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Schließen") {
                
                    dismiss()
                }
            }
        }
        .navigationTitle("Informationen")
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InfoView()
        }
    }
}
