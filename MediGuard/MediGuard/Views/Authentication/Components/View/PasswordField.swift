//
//  PasswordField.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

struct PasswordField: View {
    
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
                .frame(height: 50)
            
            HStack {
                if isVisible {
                    TextField(title, text: $text)
                        .padding()
                } else {
                    SecureField(title, text: $text)
                        .padding()
                }
                
                Button(action: {
                    isVisible.toggle()
                }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(title: "Passwort", text: .constant(""), isVisible: .constant(false))
    }
}

