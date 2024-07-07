//
//  EditMealSheetView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//
/*
// EditMealSheetView.swift
import SwiftUI

struct EditMealSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mealViewModel: MealDetailViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var meal: Meal

    @State private var intakeTime: Date = Date()
    @State private var description: String = ""
    @State private var photo: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var showAlert = false
    @State private var showConfirmSaveAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name des Essens")) {
                    TextField("Name", text: $meal.name)
                }

                Section(header: Text("Uhrzeit der Mahlzeit")) {
                    DatePicker("Uhrzeit", selection: $intakeTime, displayedComponents: .hourAndMinute)
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
                    } else if let photoURL = meal.photoURL, let url = URL(string: photoURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .onTapGesture {
                                    isImagePickerPresented = true
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Button("Foto hinzufügen") {
                            isImagePickerPresented = true
                        }
                    }
                }
            }
            .navigationBarTitle("Essen bearbeiten", displayMode: .inline)
            .navigationBarItems(leading: Button("Abbrechen") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Speichern") {
                validateAndSaveMeal()
            })
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $photo)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fehler"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showConfirmSaveAlert) {
                Alert(
                    title: Text("Änderungen speichern"),
                    message: Text("Möchten Sie die Änderungen wirklich speichern?"),
                    primaryButton: .default(Text("Ja")) {
                        saveMeal()
                    },
                    secondaryButton: .cancel(Text("Nein"))
                )
            }
        }
        .onAppear {
            intakeTime = meal.intakeDate
            description = meal.description
        }
    }

    private func validateAndSaveMeal() {
        if meal.name.isEmpty || description.isEmpty {
            alertMessage = "Bitte füllen Sie alle Felder aus."
            showAlert = true
        } else {
            showConfirmSaveAlert = true
        }
    }

    private func saveMeal() {
        if let userId = userViewModel.userId {
            if let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.8) {
                mealViewModel.selectedImageData = imageData
                mealViewModel.uploadImage(userId: userId, mealId: meal.id ?? "") { url in
                    if let url = url {
                        updateMeal(with: url)
                    }
                }
            } else {
                updateMeal(with: meal.photoURL)
            }
        }
    }

    private func updateMeal(with url: String?) {
        meal.intakeDate = intakeTime
        meal.photoURL = url
        meal.description = description
        mealViewModel.updateMeal(meal, userId: userViewModel.userId ?? "")
        self.presentationMode.wrappedValue.dismiss()
    }
}
*/



