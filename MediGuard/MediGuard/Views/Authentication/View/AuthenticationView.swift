//
//  AuthenticationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

/**
 Die `AuthenticationView`-Struktur ist eine SwiftUI-View, die die Benutzeroberfläche für die Benutzer-Authentifizierung darstellt.
 
 Diese View ermöglicht es dem Benutzer, sich anzumelden oder zu registrieren, basierend auf dem aktuellen Modus im `UserViewModel`.
 
 - Eigenschaften:
 - `userViewModel`: Das `UserViewModel`-Objekt, das die Authentifizierungslogik und -daten verwaltet.
 - `isPasswordVisible`: Boolean-Wert, der angibt, ob das Passwort sichtbar ist.
 - `isConfirmPasswordVisible`: Boolean-Wert, der angibt, ob das Bestätigungspasswort sichtbar ist.
 - `showAlert`: Boolean-Wert, der angibt, ob ein Alert angezeigt werden soll.
 */
struct AuthenticationView: View {
    
    // MARK: - Properties
    
    // Zugriff auf das UserViewModel (verwaltet Benutzerdaten und Anmelde-/Registrierungslogik)
    @EnvironmentObject private var userViewModel: UserViewModel
    // Zugriff auf das CityViewModel (verwaltet Städtedaten für die Autovervollständigung)
    @EnvironmentObject private var cityViewModel: CityViewModel
    
    // Zustandsvariablen für die Sichtbarkeit von Passwörtern und Fehlermeldungen
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showAlert = false
    // Zustandsvariable für die Sichtbarkeit des Dropdown-Menüs
    @State private var textFieldPosition: CGFloat = 0
        
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Logo und Header
            Spacer()
            VStack(spacing: 12) {
                // Anzeige des Logos der App
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                
                // Header-Text, der je nach Modus entweder "Anmelden" oder "Registrieren" anzeigt
                Text(userViewModel.mode.headerText)
                    .foregroundStyle(.blue)
                    .font(Fonts.largeTitle)
            }
            .padding(.top, 50)
            
            
            
            // MARK: - Eingabefelder
            
            VStack(spacing: 12) {
                // Eingabefeld für den Namen
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(height: 50)
                    
                    TextField("Name", text: $userViewModel.name)
                        .padding()
                        .font(Fonts.headline)
                }
                
                
                // Wenn der Modus des Benutzer-ViewModels "register" ist, zeige das folgende UI-Element an.
                if userViewModel.mode == .register {
                    // Ein ZStack, der die Elemente übereinander stapelt, mit der oberen linken Ecke als Ausrichtungspunkt.
                    ZStack(alignment: .topLeading) {
                        // Ein VStack, das die Elemente vertikal stapelt, links ausgerichtet.
                        VStack(alignment: .leading) {
                            // Ein weiterer ZStack, der die Elemente übereinander stapelt, links ausgerichtet.
                            ZStack(alignment: .leading) {
                                // Eine abgerundete Rechteckform, die einen blauen Rahmen hat.
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(height: 50)
                                
                                // Ein Textfeld für die Eingabe des Wohnorts, gebunden an `searchText` im `cityViewModel`.
                                TextField("Wohnort", text: $cityViewModel.searchText)
                                    .padding()// Fügt Padding um das Textfeld hinzu.
                                    .font(Fonts.headline)// Setzt die Schriftart auf `headline`.
                                    .onChange(of: cityViewModel.searchText) { oldValue, newValue in
                                        // Wenn der neue Text mindestens 2 Zeichen lang ist, sucht es nach Städten.
                                        if newValue.count >= 2 {
                                            cityViewModel.searchCities(byName: newValue)
                                        } else {
                                            // Wenn der Text weniger als 2 Zeichen lang ist, leere die Liste der Städte.
                                            cityViewModel.cities = []
                                        }
                                    }
                            }
                        }
                    
                

                        // Wenn die Liste der Städte im `cityViewModel` nicht leer ist, zeigt es die folgende Ansicht an.
                        if !cityViewModel.cities.isEmpty {
                            // Ein VStack, das die Städte vertikal stapelt, zentriert mit 0 Abstand zwischen den Elementen.
                            VStack(alignment: .center, spacing: 0) {
                                // Für jede Stadt in der Liste der Städte zeige einen Text mit dem Stadtnamen an.
                                ForEach(cityViewModel.cities, id: \.name) { city in
                                    Text(city.name)
                                        .padding()// Fügt Padding um den Text hinzu.
                                        .frame(maxWidth: .infinity, alignment: .leading)// Setzt die Breite auf das Maximum und richtet den Text links aus.
                                        .background(Color.white)// Setzt den Hintergrund auf weiß.
                                        .onTapGesture {
                                            // Beim Antippen wird der Text des Textfelds auf den Stadtnamen gesetzt und die Liste der Städte geleert.
                                            cityViewModel.searchText = city.name
                                            userViewModel.city = city.name  // Speichert den Wohnort im UserViewModel.
                                            cityViewModel.cities = []
                                        }
                                }
                            }
                            
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                            .frame(maxHeight: 150) // Begrenzt die Höhe des Dropdown-Menüs
                            
                            .position(x: UIScreen.main.bounds.width / 2.4, y: textFieldPosition + 125)// Positioniert den VStack relativ zur Bildschirmmitte.
                            .zIndex(1)// Setzt die Z-Index-Reihenfolge, um sicherzustellen, dass der VStack über anderen Elementen liegt.
                            
                            
                        }
                    }
                    
                    
                    
                    // Eingabefeld für das Passwort bei der Registrierung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                        .zIndex(-1)
                    // Eingabefeld zur Bestätigung des Passworts bei der Registrierung
                    PasswordField(title: "Passwort wiederholen", text: $userViewModel.confirmPassword, isVisible: $isConfirmPasswordVisible)
                        .zIndex(-1)
                } else {
                    // Eingabefeld für das Passwort bei der Anmeldung
                    PasswordField(title: "Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                        .zIndex(-1)
                }
            }
            .textInputAutocapitalization(.never)// Deaktiviert die automatische Großschreibung für alle Textfelder in diesem VStack
            
            
            
            // MARK: - Authentifizierungsbutton
            
            // Primärer Button, um den Authentifizierungsvorgang zu starten
            AuthButton.authenticationButton(userViewModel: userViewModel, showAlert: $showAlert)
                .alert(isPresented: $showAlert) {
                    // Anzeige eines Alerts bei Fehlern
                    Alert(title: Text("Fehler"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
            Spacer()
            
            // MARK: - Modus wechseln
            
            // Button, um zwischen Anmelde- und Registrierungsmodus zu wechseln
            AuthModeSwitchButton.switchModeButton(userViewModel: userViewModel,cityViewModel: cityViewModel)
               
                
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 36)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color("Background")) // Hier wird der Hintergrund gesetzt
        .edgesIgnoringSafeArea(.all)
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            // Überwachung von Änderungen der Fehlermeldung und Anzeige des Alerts
            showAlert = !errorMessage.isEmpty
        }
        .onAppear {
                    cityViewModel.clearSearchText() // Leert das Textfeld für den Wohnort beim Anzeigen der Ansicht
                }
    }
    
}

// MARK: - Vorschau

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())
            .environmentObject(CityViewModel())
    }
}












