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
    - daily: Ein Bool zur Steuerung der täglichen Einnahme des Medikaments.
 */
struct AddMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationAdminstrationViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var medicationName: String = ""
    @State private var intakeTime: Date = Date()
    @State private var day: Weekday = .monday
    @State private var nextIntakeTime: Date = Date()
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
            Section(header: Text("Name des Medikaments")
                .headlineBlue())
            {
                TextField("Name", text: $medicationName)
            }.customSectionStyle()
            
            // Abschnitt zur Auswahl der Einnahmezeit
            Section(header: Text("Uhrzeit der Einnahme")
                .headlineBlue()) {
                DatePicker("Uhrzeit für das Medikament", selection: $intakeTime, displayedComponents: .hourAndMinute)
            }.customSectionStyle()
            
            // Abschnitt zur Auswahl des Einnahmetages
            Section(header: Text("Tag der Einnahme")
                .headlineBlue()) {
                Picker("Tag", selection: $day) {
                    ForEach(Weekday.allCases, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
            }.customSectionStyle()
            
            // Abschnitt zur optionalen Eingabe der nächsten Einnahmezeit und des nächsten Einnahmetages
            Section(header: Text("Nächstes Einnahmedatum (optional)")
                .headlineBlue()) {
                Picker("Nächster Tag", selection: $nextIntakeDay) {
                    // 'nil' + Weekday.allCases: Ermöglicht die Auswahl von "Keine Auswahl"
                    ForEach([nil] + Weekday.allCases, id: \.self) {
                        Text($0?.name ?? "Keine Auswahl").tag($0)
                    }
                }
                if nextIntakeDay != nil {
                    DatePicker("Nächste Uhrzeit", selection: $nextIntakeTime, displayedComponents: .hourAndMinute)
                }
            }.customSectionStyle()
            
            // Abschnitt zur Auswahl der täglichen Einnahme
            Section(header: Text("Tägliche Einnahme (optional)")
                .headlineBlue()) {
                Toggle("Täglich", isOn: $daily)
            }.customSectionStyle()
                
            // Abschnitt zur Auswahl der Farbe der Medikamentenkarte
            Section(header: Text("Farbe der Karte")
                .headlineBlue()) {
                Picker("Farbe", selection: $selectedColor) {
                    ForEach(MedicationColor.allCases, id: \.self) { color in
                        Text(color.rawValue.capitalized).tag(color)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }.customSectionStyle()
            
            // Abschnitt zur Eingabe der Dosierung und der Dosierungseinheit
            Section(header: Text("Dosierung")
                .headlineBlue()) {
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
                .customSectionStyle()
        }
        
        .navigationBarTitle("Neues Medikament", displayMode: .inline)
        .navigationBarItems(leading: Button("Abbrechen") {
            self.presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Hinzufügen") {
            do {
                // Konvertiert die Einnahmezeit in DateComponents
                let intakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: intakeTime)
                var nextIntakeTimeComponents: DateComponents? = nil
                if let nextDay = nextIntakeDay {
                    nextIntakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: nextIntakeTime)
                    nextIntakeTimeComponents?.weekday = nextDay.rawValue
                }
                // Fügt das neue Medikament hinzu und schließt das Formular
                try medicationViewModel.addMedication(name: medicationName, intakeTime: intakeTimeComponents, day: day.rawValue, nextIntakeDate: nextIntakeTimeComponents, color: selectedColor, dosage: dosage, dosageUnit: dosageUnit, userId: userViewModel.userId ?? "", daily: daily)
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
            Alert(title: Text("Fehler").bodyBlue(), message: Text(alertMessage).bodyBlue(), dismissButton: .default(Text("OK").bodyBlue()))
        }
        .onAppear {
            nextIntakeTime = Date()
        }
       
    }
    
    
}

