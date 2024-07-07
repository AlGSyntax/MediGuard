//
//  AddMealSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI

/**
 Eine Ansicht zum Hinzufügen einer neuen Mahlzeit.
 
 Diese Ansicht ermöglicht es dem Benutzer, eine neue Mahlzeit hinzuzufügen, einschließlich Name, Beschreibung, Uhrzeit und einem optionalen Foto.
 Die hinzugefügten Daten werden an das MealAdministrationViewModel weitergeleitet, um sie in der Datenbank zu speichern.

 - Eigenschaften:
    - presentationMode: Die Umgebungsvariable zum Steuern der Darstellung dieser Ansicht.
    - mealViewModel: Das ViewModel zur Verwaltung der Mahlzeiten.
    - userViewModel: Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    - selectedDate: Das ausgewählte Datum für die neue Mahlzeit.
    - selectedTime: Die ausgewählte Uhrzeit für die neue Mahlzeit.
    - mealName: Der Name der neuen Mahlzeit.
    - description: Die Beschreibung der neuen Mahlzeit.
    - photo: Das Foto der neuen Mahlzeit.
    - isImagePickerPresented: Zustand zur Steuerung der Anzeige des Image Pickers.
 */
struct AddMealSheetView: View {
    // MARK: - Properties
    
    /// Die Umgebungsvariable zum Steuern der Darstellung dieser Ansicht.
    @Environment(\.presentationMode) var presentationMode
    
    /// Das ViewModel zur Verwaltung der Mahlzeiten.
    @ObservedObject var mealViewModel: MealAdministrationViewModel
    
    /// Das ViewModel des Benutzers, bereitgestellt durch die Umgebung.
    @EnvironmentObject var userViewModel: UserViewModel
    
    /// Das ausgewählte Datum für die neue Mahlzeit.
    @Binding var selectedDate: Date
    
    /// Die ausgewählte Uhrzeit für die neue Mahlzeit.
    @Binding var selectedTime: String

    /// Der Name der neuen Mahlzeit.
    @State private var mealName: String = ""
    
    /// Die Beschreibung der neuen Mahlzeit.
    @State private var description: String = ""
    
    /// Das Foto der neuen Mahlzeit.
    @State private var photo: UIImage? = nil
    
    /// Zustand zur Steuerung der Anzeige des Image Pickers.
    @State private var isImagePickerPresented = false

    // MARK: - Body
    
    var body: some View {
        Form {
            Section(header: Text("Name des Essens")) {
                TextField("Name", text: $mealName)
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
            mealViewModel.validateAndAddMeal(
                userId: userViewModel.userId,
                mealName: mealName,
                description: description,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                photo: photo
            )
            self.presentationMode.wrappedValue.dismiss()
        })
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $photo)
        }
        .alert(isPresented: $mealViewModel.showAlert) {
            Alert(title: Text("Fehler"), message: Text(mealViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if selectedTime.isEmpty {
                selectedTime = DateFormatter.localizedString(from: selectedDate, dateStyle: .none, timeStyle: .short)
            }
        }
    }
}

// MARK: - Preview

struct AddMealSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let mealViewModel = MealAdministrationViewModel()
        let userViewModel = UserViewModel()
        
        return AddMealSheetView(
            mealViewModel: mealViewModel,
            selectedDate: .constant(Date()),
            selectedTime: .constant("12:00")
        )
        .environmentObject(userViewModel)
    }
}



