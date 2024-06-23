//
//  EditMedicationSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

// MARK: - EditMedicationSheetView

/**
 Die EditMedicationSheetView-Struktur ist eine SwiftUI-View, die eine Eingabeoberfläche zum Bearbeiten eines bestehenden Medikaments bereitstellt.
 
 - Eigenschaften:
    - medicationViewModel: Das MedicationDetailViewModel-Objekt, das die Daten und Logik für die Medikamentenverwaltung verwaltet.
    - userViewModel: Das UserViewModel-Objekt, das die Benutzerdaten und Authentifizierungslogik verwaltet.
    - medication: Das zu bearbeitende Medikament.
    - selectedColor: Die Farbe der Medikamentenkarte.
    - dosage: Die Dosierung des Medikaments.
    - dosageUnit: Die Einheit der Dosierung.
    - intakeTime: Die Uhrzeit der Einnahme des Medikaments.
    - nextIntakeTime: Die nächste Uhrzeit der Einnahme des Medikaments (optional).
    - nextIntakeDay: Der nächste Wochentag der Einnahme des Medikaments (optional).
 */
struct EditMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationDetailViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var medication: Medication

    @State private var selectedColor: MedicationColor = .blue
    @State private var dosage: Int = 0
    @State private var dosageUnit: DosageUnit = .mg
    @State private var intakeTime: String = "08:00"
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: Weekday?
    @State private var showSaveConfirmation = false
    @State private var showDeleteConfirmation = false

    // MARK: - Body
    var body: some View {
        Form {
            // MARK: - Name des Medikaments
            Section(header: Text("Name des Medikaments")) {
                TextField("Name", text: $medication.name)
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
                Picker("Tag", selection: $medication.day) {
                    ForEach(Weekday.allCases.map { $0.name }, id: \.self) {
                        Text($0).tag($0)
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
        .navigationBarTitle("Medikament bearbeiten", displayMode: .inline)
        .navigationBarItems(leading: Button("Abbrechen") {
            self.presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Speichern") {
            showSaveConfirmation.toggle()
        })
        .alert(isPresented: $showSaveConfirmation) {
            // MARK: - Speicherbestätigung
            Alert(
                title: Text("Speichern bestätigen"),
                message: Text("Möchten Sie die Änderungen an diesem Medikament wirklich speichern?"),
                primaryButton: .default(Text("Speichern")) {
                    if let userId = userViewModel.userId {
                        let intakeTimeComponents = getTimeComponents(from: intakeTime)
                        medication.intakeTime = intakeTimeComponents
                        if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                            var nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                            nextIntakeTimeComponents.weekday = nextDay.rawValue
                            medication.nextIntakeDate = nextIntakeTimeComponents
                        } else {
                            medication.nextIntakeDate = nil
                        }
                        medication.color = selectedColor
                        medication.dosage = dosage
                        medication.dosageUnit = dosageUnit
                        medicationViewModel.updateMedication(medication, userId: userId)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Abbrechen"))
            )
        }
        .onAppear {
            selectedColor = medication.color
            dosage = medication.dosage
            dosageUnit = medication.dosageUnit
            intakeTime = "\(medication.intakeTime.hour ?? 8):\(String(format: "%02d", medication.intakeTime.minute ?? 0))"
            if let nextDate = medication.nextIntakeDate {
                nextIntakeDay = Weekday.from(nextDate.weekday)
                nextIntakeTime = "\(nextDate.hour ?? 8):\(String(format: "%02d", nextDate.minute ?? 0))"
            }
        }
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




