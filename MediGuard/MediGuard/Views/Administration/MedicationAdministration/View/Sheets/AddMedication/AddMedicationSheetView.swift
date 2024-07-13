//
//  AddMedicationSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//


import SwiftUI


// MARK: - AddMedicationSheetView Struktur

/**
 Die AddMedicationSheetView-Struktur ist eine Ansicht, die ein Formular zum Hinzufügen eines neuen Medikaments bereitstellt.
 
 - Eigenschaften:
    - presentationMode: Eine Umgebungseigenschaft, die den Präsentationsmodus der Ansicht steuert.
    - medicationViewModel: Das ViewModel für die Medikamentendetails.
    - userViewModel: Das ViewModel für den Benutzer, das Informationen über den aktuellen Benutzer enthält.
    - medicationName: Der Name des Medikaments.
    - intakeTime: Die Uhrzeit der Einnahme des Medikaments.
    - day: Der Tag der Einnahme des Medikaments.
    - nextIntakeTime: Die Uhrzeit der nächsten Einnahme des Medikaments (optional).
    - nextIntakeDay: Der Tag der nächsten Einnahme des Medikaments (optional).
    - selectedColor: Die Farbe der Medikamentenkarte.
    - dosage: Die Dosierung des Medikaments.
    - dosageUnit: Die Einheit der Dosierung des Medikaments.
    - showSaveConfirmation: Ein Bool zur Steuerung der Anzeige der Bestätigungsspeicherung.
    - showAlert: Ein Bool zur Steuerung der Anzeige von Fehlermeldungen.
    - alertMessage: Die Fehlermeldung, die angezeigt wird.
 */
struct AddMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationAdminstrationViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var medicationName: String = ""
    @State private var intakeTime: Date = Date()
    @State private var day: Weekday = .monday
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: Weekday?
    @State private var selectedColor: MedicationColor = .blue
    @State private var dosage: Int = 10
    @State private var dosageUnit: DosageUnit = .mg
    @State private var showSaveConfirmation = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var daily: Bool = false

    
    // MARK: - Body
    var body: some View {
        Form {
            // Abschnitt zur Eingabe des Medikamentennamens
            Section(header: Text("Name des Medikaments")) {
                TextField("Name", text: $medicationName)
            }
            
            // Abschnitt zur Auswahl der Einnahmezeit
            Section(header: Text("Uhrzeit der Einnahme")) {
                            DatePicker("Uhrzeit", selection: $intakeTime, displayedComponents: .hourAndMinute)
                        }
            
            // Abschnitt zur Auswahl des Einnahmetages
            Section(header: Text("Tag der Einnahme")) {
                Picker("Tag", selection: $day) {
                    ForEach(Weekday.allCases, id: \.self) {
                        Text($0.name).tag($0)
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
            
            
            // Abschnitt zur Auswahl der täglichen Einnahme
                        Section {
                            Toggle("Täglich", isOn: $daily)
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
        .navigationBarTitle("Neues Medikament", displayMode: .inline)
        .navigationBarItems(leading: Button("Abbrechen") {
            self.presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Hinzufügen") {
            
                do {
                                // Konvertiert die Einnahmezeit in DateComponents
                                let intakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: intakeTime)
                                var nextIntakeTimeComponents: DateComponents? = nil
                                if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                                    nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                                    nextIntakeTimeComponents?.weekday = nextDay.rawValue
                                }
                                // Fügt das neue Medikament hinzu und schließt das Formular
                                try medicationViewModel.addMedication(name: medicationName, intakeTime: intakeTimeComponents, day: day.name, nextIntakeDate: nextIntakeTimeComponents, color: selectedColor, dosage: dosage, dosageUnit: dosageUnit, userId: userViewModel.userId ?? "", daily: daily)
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
