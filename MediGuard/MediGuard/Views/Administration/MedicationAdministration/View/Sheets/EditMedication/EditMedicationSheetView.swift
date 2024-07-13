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
    @State private var intakeTime: Date = Date()
    @State private var nextIntakeTime: Date?
    @State private var nextIntakeDay: Weekday?
    @State private var showSaveConfirmation = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var daily: Bool = false
    @State private var showConfirmationAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Name des Medikaments")) {
                TextField("Name", text: $medication.name)
            }
            
            Section(header: Text("Uhrzeit der Einnahme")) {
                DatePicker("Uhrzeit", selection: $intakeTime, displayedComponents: .hourAndMinute)
            }
            
            Section(header: Text("Tag der Einnahme")) {
                Picker("Tag", selection: $medication.day) {
                    ForEach(Weekday.allCases.map { $0.name }, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            
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
            
            Section {
                Toggle("Täglich", isOn: $daily)
            }
            
            Section(header: Text("Farbe der Karte")) {
                Picker("Farbe", selection: $selectedColor) {
                    ForEach(MedicationColor.allCases, id: \.self) { color in
                        Text(color.rawValue.capitalized).tag(color)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
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
            self.showConfirmationAlert = true
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Fehler"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Änderungen bestätigen"),
                message: Text("Bist du mit den Änderungen einverstanden?"),
                primaryButton: .default(Text("Ja")) {
                    Task {
                        do {
                            let intakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: intakeTime)
                            medication.intakeTime = intakeTimeComponents
                            if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                                var nextIntakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: nextTime)
                                nextIntakeTimeComponents.weekday = nextDay.rawValue
                                medication.nextIntakeDate = nextIntakeTimeComponents
                            } else {
                                medication.nextIntakeDate = nil
                            }
                            medication.color = selectedColor
                            medication.dosage = dosage
                            medication.dosageUnit = dosageUnit
                            medication.daily = daily
                            
                            try await medicationViewModel.updateMedication(medication, userId: userViewModel.userId ?? "")
                            self.presentationMode.wrappedValue.dismiss()
                        } catch let error as ValidationError {
                            alertMessage = error.errorDescription ?? "Unbekannter Fehler"
                            showAlert = true
                        } catch {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                },
                secondaryButton: .cancel(Text("Nein"))
            )
        }
        .onAppear {
            selectedColor = medication.color
            dosage = medication.dosage
            dosageUnit = medication.dosageUnit
            intakeTime = Calendar.current.date(from: medication.intakeTime) ?? Date()
            if let nextDate = medication.nextIntakeDate {
                nextIntakeDay = Weekday.from(nextDate.weekday)
                nextIntakeTime = Calendar.current.date(from: nextDate)
            }
            daily = medication.daily
        }
    }
    
    
    private func getTimeComponents(from time: String) -> DateComponents {
        let parts = time.split(separator: ":").map { Int($0) }
        return DateComponents(hour: parts[0], minute: parts[1])
    }
}




