//
//  AddMealSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI

struct AddMealSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mealViewModel: MealDetailViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var mealName: String = ""
    @State private var intakeTime: String = "08:00"
    @State private var day: String = "Montag"
    @State private var nextIntakeTime: String?
    @State private var nextIntakeDay: String?
    @State private var description: String = ""
    @State private var photo: UIImage? = nil
    @State private var photoURL: String? = nil

    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name des Essens")) {
                    TextField("Name", text: $mealName)
                }

                Section(header: Text("Uhrzeit der Mahlzeit")) {
                    Picker("Uhrzeit", selection: $intakeTime) {
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }

                Section(header: Text("Tag der Mahlzeit")) {
                    Picker("Tag", selection: $day) {
                        ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }

                Section(header: Text("Nächstes Mahlzeitdatum (optional)")) {
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

                Section(header: Text("Beschreibung")) {
                    TextField("Beschreibung", text: $description)
                }

                Section(header: Text("Foto")) {
                    if let photo = photo {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    } else {
                        Button("Foto hinzufügen") {
                            isImagePickerPresented = true
                        }
                    }
                }
            }
            .navigationBarTitle("Neues Essen", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Hinzufügen") {
                if let userId = userViewModel.userId {
                    mealViewModel.uploadImage(image: photo ?? UIImage()) { url in
                        if let url = url {
                            let intakeTimeComponents = getTimeComponents(from: intakeTime)
                            var nextIntakeTimeComponents: DateComponents? = nil
                            if let nextDay = nextIntakeDay, let nextTime = nextIntakeTime {
                                nextIntakeTimeComponents = getTimeComponents(from: nextTime)
                                nextIntakeTimeComponents?.weekday = getWeekdayIndex(from: nextDay)
                            }
                            mealViewModel.addMeal(name: mealName, intakeTime: intakeTimeComponents, day: day, nextIntakeDate: nextIntakeTimeComponents, photoURL: url, description: description, userId: userId)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $photo)
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
}

