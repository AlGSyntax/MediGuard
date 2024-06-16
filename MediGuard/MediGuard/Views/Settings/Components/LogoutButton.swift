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
 */
struct LogoutButton: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            userViewModel.logout()
        }) {
            Text("Abmelden")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(12)
                .padding(.horizontal)
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

