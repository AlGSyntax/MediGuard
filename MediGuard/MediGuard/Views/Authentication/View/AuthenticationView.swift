//
//  AuthenticationView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text(userViewModel.mode.headerText)
                    .foregroundColor(.blue)
                    .font(.system(size: 28, weight: .bold))
            }
            .padding(.top, 50)
            
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 50)
                    
                    TextField("Name", text: $userViewModel.name)
                        .padding()
                }
                
                if userViewModel.mode == .register {
                    passwordField("Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                    passwordField("Passwort wiederholen", text: $userViewModel.confirmPassword, isVisible: $isConfirmPasswordVisible)
                } else {
                    passwordField("Passwort", text: $userViewModel.password, isVisible: $isPasswordVisible)
                }
            }
            .font(.headline)
            .textInputAutocapitalization(.never)
            
            PrimaryButton(title: userViewModel.mode.title, action: {
                if userViewModel.disableAuthentication {
                    if userViewModel.name.isEmpty {
                        userViewModel.errorMessage = "Bitte geben Sie einen Namen ein."
                    } else if userViewModel.password.isEmpty {
                        userViewModel.errorMessage = "Bitte geben Sie ein Passwort ein."
                    } else if userViewModel.mode == .register && userViewModel.confirmPassword.isEmpty {
                        userViewModel.errorMessage = "Bitte wiederholen Sie das Passwort."
                    } else if userViewModel.mode == .register && userViewModel.password != userViewModel.confirmPassword {
                        userViewModel.errorMessage = "Die Passwörter stimmen nicht überein."
                    }
                    showAlert = true
                } else {
                    userViewModel.authenticate()
                    userViewModel.clearFields()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fehler"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            
            TextButton(title: userViewModel.mode.alternativeTitle) {
                withAnimation {
                    userViewModel.switchAuthenticationMode()
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .cornerRadius(12)
        .padding(.horizontal, 36)
        .frame(maxHeight: .infinity, alignment: .top)
        .onReceive(userViewModel.$errorMessage) { errorMessage in
            showAlert = !errorMessage.isEmpty
        }
    }
    
    @ViewBuilder
    private func passwordField(_ title: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
                .frame(height: 50)
            
            HStack {
                if isVisible.wrappedValue {
                    TextField(title, text: text)
                        .padding()
                } else {
                    SecureField(title, text: text)
                        .padding()
                }
                
                Button(action: {
                    isVisible.wrappedValue.toggle()
                }) {
                    Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())
    }
}










