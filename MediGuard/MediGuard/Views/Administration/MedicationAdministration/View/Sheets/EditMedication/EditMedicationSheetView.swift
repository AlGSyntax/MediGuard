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
 - daily: Ein Bool zur Steuerung der täglichen Einnahme.
 - showConfirmationAlert: Ein Bool zur Steuerung der Anzeige des Bestätigungsalerts.
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
    @State private var nextIntakeTime: Date = Date()
    @State private var nextIntakeDay: Weekday?
    @State private var showSaveConfirmation = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var daily: Bool = false
    @State private var showConfirmationAlert = false
    
    
    // MARK: - Body
    
    var body: some View {
        Form {
            
            // Sektion für den Namen des Medikaments
            Section(header: Text("Name des Medikaments")
                .headlineBlue()) {
                TextField("Name", text: $medication.name)
                        
                        
                }
                .customSectionStyle()
            
            // Sektion für die Uhrzeit der Einnahme
            Section(header: Text("Uhrzeit der Einnahme")
                .headlineBlue()) {
                DatePicker("Uhrzeit", selection: $intakeTime, displayedComponents: .hourAndMinute)
            }
                .customSectionStyle()
            
            // Sektion für den Tag der Einnahme
            Section(header: Text("Tag der Einnahme")
                .headlineBlue()) {
                Picker("Tag", selection: $medication.day) {
                    ForEach(Weekday.allCases.map { $0.name }, id: \.self) {
                        Text($0).tag($0)
                            .font(Fonts.body)
                            
                    }
                }
            }
                .customSectionStyle()
            
            // Sektion für das nächste Einnahmedatum (optional)
            Section(header: Text("Nächstes Einnahmedatum (optional)")
                .headlineBlue()) {
                Picker("Nächster Tag", selection: $nextIntakeDay) {
                    // 'nil' + Weekday.allCases: Ermöglicht die Auswahl von "Keine Auswahl"
                    ForEach([nil] + Weekday.allCases, id: \.self) {
                        Text($0?.name ?? "Keine Auswahl").tag($0)
                            
                    }
                }
                if nextIntakeDay != nil {
                    DatePicker("Uhrzeit", selection: $nextIntakeTime, displayedComponents: .hourAndMinute)
                        .onAppear {
                            
                                nextIntakeTime = Date()
                            
                        }
                }
            }
                .customSectionStyle()
            
            // Sektion für die tägliche Einnahme
            Section(header: Text("Tägliche Einnahme (optional)")
                .headlineBlue())
            {
                Toggle("", isOn: $daily)
            }
            .customSectionStyle()
            
            // Sektion für die Farbe der Medikamentenkarte
            Section(header: Text("Farbe der Karte")
                .headlineBlue()) {
                Picker("Farbe", selection: $selectedColor) {
                    ForEach(MedicationColor.allCases, id: \.self) { color in
                        Text(color.rawValue.capitalized).tag(color)
                            
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
                .customSectionStyle()
            
            // Sektion für die Dosierung des Medikaments
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
        // Setzt den Hintergrund der gesamten Ansicht
                .background(Color("Background").ignoresSafeArea())
        .navigationBarTitle("Medikament bearbeiten", displayMode: .inline)
        .navigationBarItems(leading: Button("Abbrechen") {
            self.presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Speichern") {
            self.showConfirmationAlert = true
        })
        // Fehler-Alert
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Fehler")
                .font(Fonts.title1)
                .foregroundStyle(.red), message: Text(alertMessage), dismissButton: .default(Text("OK")
                    .font(Fonts.body)
                    .foregroundStyle(.blue)))
        }
        // Bestätigungs-Alert
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Änderungen bestätigen")
                    .bodyBlue()
                        
                    ,
                message: Text("Bist du mit den Änderungen einverstanden?")
                    .bodyBlue(),
                primaryButton: .default(Text("Ja")
                    .bodyBlue()) {
                    Task {
                        do {
                            // Extrahiert Stunden- und Minutenkomponenten aus der Einnahmezeit
                            let intakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: intakeTime)
                            medication.intakeTime = intakeTimeComponents
                            if let nextDay = nextIntakeDay {
                                // Setzt das nächste Einnahmedatum
                                var nextIntakeTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: nextIntakeTime)
                                nextIntakeTimeComponents.weekday = nextDay.rawValue
                                medication.nextIntakeDate = nextIntakeTimeComponents
                            } else {
                                medication.nextIntakeDate = nil
                            }
                            // Setzt weitere Eigenschaften des Medikaments
                            medication.color = selectedColor
                            medication.dosage = dosage
                            medication.dosageUnit = dosageUnit
                            medication.daily = daily
                            
                            // Aktualisiert das Medikament im ViewModel
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
                secondaryButton: .cancel(Text("Nein")
                    .bodyBlue())
            )
        }
        // Setzt die initialen Werte bei Erscheinen der Ansicht
        .onAppear {
            selectedColor = medication.color
            dosage = medication.dosage
            dosageUnit = medication.dosageUnit
            intakeTime = Calendar.current.date(from: medication.intakeTime) ?? Date()
            if let nextDate = medication.nextIntakeDate {
                nextIntakeDay = Weekday.from(nextDate.weekday)
                nextIntakeTime = Calendar.current.date(from: nextDate) ?? Date()
            }
            daily = medication.daily
        }
        

    }
  
    
   
}




