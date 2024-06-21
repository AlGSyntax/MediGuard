//
//  AddMedicationSheet.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

struct AddMedicationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var medicationViewModel: MedicationDetailViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var medicationName: String = ""
    @State private var intakeTime: String = "08:00"
    @State private var day: String = "Montag"
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: String?
    @State private var selectedColor: MedicationColor = .blue
    @State private var dosage: Int = 0
    @State private var dosageUnit: DosageUnit = .mg

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name des Medikaments")) {
                    TextField("Name", text: $medicationName)
                }

                Section(header: Text("Uhrzeit der Einnahme")) {
                    Picker("Uhrzeit", selection: $intakeTime) {
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }

                Section(header: Text("Tag der Einnahme")) {
                    Picker("Tag", selection: $day) {
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
            .navigationBarTitle("Neues Medikament", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Hinzufügen") {
                if let userId = userViewModel.userId {
                    let intakeTimeComponents = getTimeComponents(from: intakeTime)
                    var nextIntakeTimeComponents: DateComponents? = nil
                    if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                        nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                        nextIntakeTimeComponents?.weekday = getWeekdayIndex(from: nextDay)
                        print("Next Intake Day: \(nextDay), Time: \(nextTime), Components: \(String(describing: nextIntakeTimeComponents))")
                    }
                    print("Intake Time Components: \(intakeTimeComponents)")
                    medicationViewModel.addMedication(name: medicationName, intakeTime: intakeTimeComponents, day: day, nextIntakeDate: nextIntakeTimeComponents, color: selectedColor, dosage: dosage, dosageUnit: dosageUnit, userId: userId)
                }
                self.presentationMode.wrappedValue.dismiss()
            })
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
}










