//
//  EditMedicationSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

// MARK: - EditMedicationSheetView Struktur

/**
 Die EditMedicationSheetView-Struktur ist eine Ansicht, die ein Formular zum Bearbeiten eines vorhandenen Medikaments bereitstellt.
 
 - Eigenschaften:
    - presentationMode: Eine Umgebungseigenschaft, die den Präsentationsmodus der Ansicht steuert.
    - medicationViewModel: Das ViewModel für die Medikamentendetails.
    - userViewModel: Das ViewModel für den Benutzer, das Informationen über den aktuellen Benutzer enthält.
    - medication: Das zu bearbeitende Medikament.
    - selectedColor: Die Farbe der Medikamentenkarte.
    - dosage: Die Dosierung des Medikaments.
    - dosageUnit: Die Einheit der Dosierung des Medikaments.
    - intakeTime: Die Uhrzeit der Einnahme des Medikaments.
    - nextIntakeTime: Die Uhrzeit der nächsten Einnahme des Medikaments (optional).
    - nextIntakeDay: Der Tag der nächsten Einnahme des Medikaments (optional).
    - showSaveConfirmation: Ein Bool zur Steuerung der Anzeige der Bestätigungsspeicherung.
    - showAlert: Ein Bool zur Steuerung der Anzeige von Fehlermeldungen.
    - alertMessage: Die Fehlermeldung, die angezeigt wird.
 */

struct EditMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationAdminstrationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var medication: Medication

    @State private var selectedColor: MedicationColor = .blue
    @State private var dosage: Int = 10
    @State private var dosageUnit: DosageUnit = .mg
    @State private var intakeTime: String = "08:00"
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: Weekday?
    @State private var showSaveConfirmation = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    // MARK: - Body
    var body: some View {
        Form {
            // Abschnitt zur Eingabe des Medikamentennamens
            Section(header: Text("Name des Medikaments")) {
                TextField("Name", text: $medication.name)
            }
            
            // Abschnitt zur Auswahl der Einnahmezeit
            Section(header: Text("Uhrzeit der Einnahme")) {
                Picker("Uhrzeit", selection: $intakeTime) {
                    ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            
            // Abschnitt zur Auswahl des Einnahmetages
            Section(header: Text("Tag der Einnahme")) {
                Picker("Tag", selection: $medication.day) {
                    ForEach(Weekday.allCases.map { $0.name }, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            
            // Abschnitt zur optionalen Eingabe der nächsten Einnahmezeit und des nächsten Einnahmetages
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
            
            // Abschnitt zur Auswahl der Farbe der Medikamentenkarte
            Section(header: Text("Farbe der Karte")) {
                Picker("Farbe", selection: $selectedColor) {
                    ForEach(MedicationColor.allCases, id: \.self) { color in
                        Text(color.rawValue.capitalized).tag(color)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Abschnitt zur Eingabe der Dosierung und der Dosierungseinheit
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
            do {
                // Konvertiert die Einnahmezeit in DateComponents und aktualisiert das Medikament
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
                
                // Aktualisiert das Medikament im ViewModel und schließt das Formular
                try medicationViewModel.updateMedication(medication, userId: userViewModel.userId ?? "")
                self.presentationMode.wrappedValue.dismiss()
            } catch let error as ValidationError {
                // Fehlerbehandlung für Validierungsfehler
                alertMessage = error.errorDescription ?? "Unbekannter Fehler"
                showAlert = true
            } catch {
                // Allgemeine Fehlerbehandlung
                alertMessage = error.localizedDescription
                showAlert = true
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Fehler"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Setzt die initialen Werte der Zustandsvariablen beim Anzeigen des Formulars
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
         Konvertiert eine Uhrzeit in DateComponents.
         
         - Parameter time: Die Uhrzeit im Format "HH:mm".
         - Returns: Die DateComponents für die angegebene Uhrzeit.
         */
    private func getTimeComponents(from time: String) -> DateComponents {
        let parts = time.split(separator: ":").map { Int($0) }
        return DateComponents(hour: parts[0], minute: parts[1])
    }
}







