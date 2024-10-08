//
//  LogOutButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 16.06.24.
//

import SwiftUI

/**
 Die `LogoutButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button zum Abmelden des Benutzers darstellt.
 
 Dieser Button ruft die `logout`-Funktion aus dem `UserViewModel` auf.
 
 - Eigenschaften:
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Benutzerdaten und -methoden verwaltet.
    - `showAlert`: Ein `@State`-Bool-Wert, der angibt, ob der Alert angezeigt werden soll.
 */
struct LogoutButton: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showAlert = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            // Zeigt den Alert an, wenn der Button gedrückt wird
            showAlert = true
        }) {
            Text("Abmelden")
                .font(Fonts.body)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
            // Definiert den Alert, der angezeigt wird
                    Alert(
                        title: Text("Abmelden"),
                        message: Text("Sind Sie sicher, dass Sie sich abmelden möchten?"),
                        primaryButton: .destructive(Text("Abmelden")) {
                            // Ruft die Methode `logout` auf, wenn "Abmelden" gedrückt wird
                            userViewModel.logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
}

// MARK: - Vorschau

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
            .environmentObject(UserViewModel())
    }
}

