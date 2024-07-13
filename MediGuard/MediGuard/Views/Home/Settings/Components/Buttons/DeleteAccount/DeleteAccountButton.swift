//
//  DeleteAccountButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.07.24.
//

import SwiftUI

/**
 Die `DeleteAccountButton`-Struktur ist eine SwiftUI-View, die einen Button darstellt,
 der die `deleteAccount`-Methode im `UserViewModel` aufruft.
 
 - Eigenschaften:
    - `userViewModel`: Das `UserViewModel`-Objekt, das die Benutzerdaten und -methoden verwaltet.
    - `showAlert`: Ein `@State`-Bool-Wert, der angibt, ob der Alert angezeigt werden soll.
 */
struct DeleteAccountButton: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            // Zeigt den Alert an, wenn der Button gedrückt wird
            showAlert = true
        }) {
            Text("Konto löschen")
                .font(Fonts.body)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
                    Alert(
                        // Definiert den Alert, der angezeigt wird
                        title: Text("Konto löschen"),
                        message: Text("Sind Sie sicher, dass Sie Ihren Account löschen möchten?"),
                        primaryButton: .destructive(Text("Löschen")) {
                            // Ruft die Methode `deleteAccount` auf, wenn "Löschen" gedrückt wird
                            userViewModel.deleteAccount()
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
}

// MARK: - Vorschau

struct DeleteAccountButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountButton()
            .environmentObject(UserViewModel())
    }
}
