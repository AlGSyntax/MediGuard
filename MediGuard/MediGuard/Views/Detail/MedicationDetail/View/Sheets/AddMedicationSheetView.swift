//
//  AddMedicationSheet.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

// MARK: - AddMedicationSheetView

/**
 Die AddMedicationSheetView-Struktur ist eine SwiftUI-View, die eine Eingabeoberfläche zum Hinzufügen eines neuen Medikaments bereitstellt.
 
 - Eigenschaften:
    - medicationViewModel: Das MedicationDetailViewModel-Objekt, das die Daten und Logik für die Medikamentenverwaltung verwaltet.
    - userViewModel: Das UserViewModel-Objekt, das die Benutzerdaten und Authentifizierungslogik verwaltet.
    - medicationName: Der Name des Medikaments.
    - intakeTime: Die Uhrzeit der Einnahme des Medikaments.
    - day: Der Wochentag der Einnahme des Medikaments.
    - nextIntakeTime: Die nächste Uhrzeit der Einnahme des Medikaments (optional).
    - nextIntakeDay: Der nächste Wochentag der Einnahme des Medikaments (optional).
    - selectedColor: Die Farbe der Medikamentenkarte.
    - dosage: Die Dosierung des Medikaments.
    - dosageUnit: Die Einheit der Dosierung.
 */
struct AddMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationDetailViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var medicationName: String = ""
    @State private var intakeTime: String = "08:00"
    @State private var day: Weekday = .monday
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: Weekday?
    @State private var selectedColor: MedicationColor = .blue
    @State private var dosage: Int = 0
    @State private var dosageUnit: DosageUnit = .mg

    // MARK: - Body
    var body: some View {
      
            Form {
                // MARK: - Name des Medikaments
                Section(header: Text("Name des Medikaments")) {
                    TextField("Name", text: $medicationName)
                }

                // MARK: - Uhrzeit der Einnahme
                Section(header: Text("Uhrzeit der Einnahme")) {
                    Picker("Uhrzeit", selection: $intakeTime) {
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }

                // MARK: - Tag der Einnahme
                Section(header: Text("Tag der Einnahme")) {
                    Picker("Tag", selection: $day) {
                        ForEach(Weekday.allCases, id: \.self) {
                            Text($0.name).tag($0)
                        }
                    }
                }

                // MARK: - Nächstes Einnahmedatum (optional)
                Section(header: Text("Nächstes Einnahmedatum (optional)")) {
                    Picker("Nächster Tag", selection: $nextIntakeDay) {
                        ForEach([nil] + Weekday.allCases, id: \.self) {
                            Text($0?.name ?? "Keine Auswahl").tag($0)
                        }
                    }
                    if nextIntakeDay != nil {
                        Picker("Nächste Uhrzeit", selection: $nextIntakeTime) {
                            ForEach([nil] + ["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                                Text($0 ?? "Keine Auswahl").tag($0)
                            }
                        }
                    }
                }

                // MARK: - Farbe der Karte
                Section(header: Text("Farbe der Karte")) {
                    Picker("Farbe", selection: $selectedColor) {
                        ForEach(MedicationColor.allCases, id: \.self) { color in
                            Text(color.rawValue.capitalized).tag(color)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // MARK: - Dosierung
                Section(header: Text("Dosierung")) {
                    HStack {
                        TextField("Dosierung", value: $dosage, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        Picker("Einheit", selection: $dosageUnit) {
                                                    ForEach(DosageUnit.allCases, id: \.self) { unit in
                                                        if let image = unit.image {
                                                            image.tag(unit)
                                                        } else {
                                                            Text(unit.displayName).tag(unit)
                                                        }
                                                    }
                                                }

                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .navigationBarTitle("Neues Medikament", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Hinzufügen") {
                if let userId = userViewModel.userId {
                    let intakeTimeComponents = getTimeComponents(from: intakeTime)
                    var nextIntakeTimeComponents: DateComponents? = nil
                    if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                        nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                        nextIntakeTimeComponents?.weekday = nextDay.rawValue
                    }
                    medicationViewModel.addMedication(name: medicationName, intakeTime: intakeTimeComponents, day: day.name, nextIntakeDate: nextIntakeTimeComponents, color: selectedColor, dosage: dosage, dosageUnit: dosageUnit, userId: userId)
                }
                self.presentationMode.wrappedValue.dismiss()
            })
        
    }

    // MARK: - Helper Methods

    /**
     Konvertiert eine Uhrzeit als String in DateComponents.
     
     - Parameter time: Die Uhrzeit als String.
     - Returns: Die entsprechenden DateComponents.
     */
    private func getTimeComponents(from time: String) -> DateComponents {
        let parts = time.split(separator: ":").map { Int($0) }
        return DateComponents(hour: parts[0], minute: parts[1])
    }
}











