//
//  EditMedicationSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

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
    @State private var nextIntakeDay: String?

    var body: some View {
        Form {
            Section(header: Text("Name des Medikaments")) {
                TextField("Name", text: $medication.name)
            }

            Section(header: Text("Uhrzeit der Einnahme")) {
                Picker("Uhrzeit", selection: $intakeTime) {
                    ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }

            Section(header: Text("Tag der Einnahme")) {
                Picker("Tag", selection: $medication.day) {
                    ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }

            Section(header: Text("Nächstes Einnahmedatum (optional)")) {
                Picker("Nächster Tag", selection: $nextIntakeDay) {
                    ForEach([nil] + ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) {
                        Text($0 ?? "Keine Auswahl").tag($0)
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
                        ForEach(DosageUnit.allCases) { unit in
                            if unit == .pills {
                                Label(unit.displayName, systemImage: "pills")
                                    .tag(unit)
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
            if let userId = userViewModel.userId {
                let intakeTimeComponents = getTimeComponents(from: intakeTime)
                medication.intakeTime = intakeTimeComponents
                if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                    var nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                    nextIntakeTimeComponents.weekday = getWeekdayIndex(from: nextDay)
                    medication.nextIntakeDate = nextIntakeTimeComponents
                    print("Next Intake Day: \(nextDay), Time: \(nextTime), Components: \(String(describing: nextIntakeTimeComponents))")
                } else {
                    medication.nextIntakeDate = nil
                }
                print("Intake Time Components: \(intakeTimeComponents)")
                medication.color = selectedColor
                medication.dosage = dosage
                medication.dosageUnit = dosageUnit
                medicationViewModel.updateMedication(medication, userId: userId)
            }
            self.presentationMode.wrappedValue.dismiss()
        })
        .onAppear {
            selectedColor = medication.color
            dosage = medication.dosage
            dosageUnit = medication.dosageUnit
            intakeTime = "\(medication.intakeTime.hour ?? 8):\(String(format: "%02d", medication.intakeTime.minute ?? 0))"
            if let nextDate = medication.nextIntakeDate {
                nextIntakeDay = getDayString(from: nextDate.weekday)
                nextIntakeTime = "\(nextDate.hour ?? 8):\(String(format: "%02d", nextDate.minute ?? 0))"
            }
        }
    }

    private func getTimeComponents(from time: String) -> DateComponents {
        let parts = time.split(separator: ":").map { Int($0) }
        return DateComponents(hour: parts[0], minute: parts[1])
    }

    private func getWeekdayIndex(from day: String) -> Int? {
        switch day {
        case "Montag": return 2
        case "Dienstag": return 3
        case "Mittwoch": return 4
        case "Donnerstag": return 5
        case "Freitag": return 6
        case "Samstag": return 7
        case "Sonntag": return 1
        default: return nil
        }
    }
    
    private func getDayString(from weekday: Int?) -> String? {
        guard let weekday = weekday else { return nil }
        switch weekday {
        case 2: return "Montag"
        case 3: return "Dienstag"
        case 4: return "Mittwoch"
        case 5: return "Donnerstag"
        case 6: return "Freitag"
        case 7: return "Samstag"
        case 1: return "Sonntag"
        default: return nil
        }
    }
}








