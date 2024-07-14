//
//  AddIntakeView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
import SwiftUI

// MARK: - AddIntakeView

/**
 Die Ansicht zum Hinzufügen einer neuen Flüssigkeitsaufnahme.

 Diese Ansicht ermöglicht es dem Benutzer, eine neue Flüssigkeitsaufnahme hinzuzufügen, indem er die Art der Flüssigkeit und die Menge auswählt.
 
 - Properties:
    - dismiss: Die Umgebungsvariable zum Schließen der Ansicht.
    - drinksViewModel: Das ViewModel zur Verwaltung der Getränkeaufnahme.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - selectedType: Der ausgewählte Typ der Flüssigkeit.
    - selectedAmount: Die ausgewählte Menge der Flüssigkeit.
    - amounts: Eine vordefinierte Liste von Mengen, die der Benutzer auswählen kann.
 */

struct AddIntakeView: View {
    // MARK: - Properties
    
    /// Die Umgebungsvariable zum Schließen der Ansicht
    @Environment(\.dismiss) private var dismiss
    
    /// Das ViewModel zur Verwaltung der Getränkeaufnahme
    @EnvironmentObject var drinksViewModel: DrinksAdministrationViewModel
    
    /// Das ViewModel des Benutzers, bereitgestellt durch die Umgebung
    @EnvironmentObject var userViewModel: UserViewModel
    
    /// Der ausgewählte Typ der Flüssigkeit
    @State private var selectedType: IntakeTypeColor = .wasser
    
    /// Die ausgewählte Menge der Flüssigkeit
    @State private var selectedAmount: Int = 100
    
    /// Eine vordefinierte Liste von Mengen, die der Benutzer auswählen kann
    private let amounts = stride(from: 100, through: 2000, by: 50).map { $0 }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            // Titel der Ansicht
            Text("Neue Eingabe")
                .headlineBlue()
            
            // Auswahl der Flüssigkeitsart
            HStack {
                Picker("Wählen Sie aus", selection: $selectedType) {
                    ForEach(IntakeTypeColor.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Image(systemName: "drop.fill")
                    .foregroundStyle(selectedType.color)
                    .font(.system(size: 40))
            }
            
            // Auswahl der Flüssigkeitsmenge
            Picker("Wählen Sie eine Menge", selection: $selectedAmount) {
                ForEach(amounts, id: \.self) { item in
                    Text("\(item) mL")
                }
            }
            .pickerStyle(.inline)
            
            // Button zum Speichern der Eingabe
            AddIntakeButton {
                // Überprüft, ob eine Benutzer-ID vorhanden ist
                           if let userId = userViewModel.userId {
                               // Erstellt eine neue Flüssigkeitsaufnahme
                               let newIntake = Intake(
                                   amount: selectedAmount,
                                   type: selectedType.rawValue,
                                   time: Date()
                               )
                               // Fügt die neue Aufnahme zum ViewModel hinzu
                               drinksViewModel.addIntake(
                                   amount: newIntake.amount,
                                   type: newIntake.type,
                                   time: newIntake.time,
                                   userId: userId
                               )
                               // Schließt die Ansicht
                               dismiss()
                           }
                       }
            // Toolbar mit einem Button zum Schließen der Ansicht
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 60)
        }
        .padding()
    }
}


// MARK: - Preview

/**
 Vorschau der `AddIntakeView`-Struktur.

 Diese Vorschau zeigt die `AddIntakeView` in Xcode's SwiftUI Preview an.
 */
struct AddIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddIntakeView()
                .environmentObject(DrinksAdministrationViewModel())
                .environmentObject(UserViewModel())
        }
    }
}
