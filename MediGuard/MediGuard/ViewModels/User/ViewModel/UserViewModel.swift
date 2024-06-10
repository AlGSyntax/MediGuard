//
//  MediGuardApp.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//


import Foundation
import FirebaseAuth

@MainActor
class UserViewModel: ObservableObject {
    
    init() {
        checkAuth()
    }
    
    // MARK: - Variables
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var user: FireUser?
    @Published var mode: AuthenticationMode = .login
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var authenticationError: AuthenticationError?
    
    // MARK: - Computed Properties
    
    var userIsLoggedIn: Bool {
        user != nil
    }
    
    var disableAuthentication: Bool {
        if mode == .register {
            return name.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
        } else {
            return name.isEmpty || password.isEmpty
        }
    }
    
    var userId: String? {
        firebaseManager.auth.currentUser?.uid
    }
    
    var nameDisplay: String {
        user?.name ?? ""
    }
    
    // MARK: - Functions
    
    func login(username: String, password: String) {
        let email = formatEmail(username)
        
        
        
        firebaseManager.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                
                self.handleAuthError(error)
                
                return
            }
            
            guard let authResult = authResult else { return }
            
            
            self.fetchUser(with: authResult.user.uid)
            
        }
    }
    
    func register(name: String, username: String, password: String) {
        let email = formatEmail(username)
        
        
        
        firebaseManager.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                
                self.handleAuthError(error)
                
                return
            }
            
            guard let authResult = authResult else { return }
            
            
            self.createUser(with: authResult.user.uid, name: name)
            self.login(username: username, password: password)
            
        }
    }
    
    func switchAuthenticationMode() {
        
        self.mode = self.mode == .login ? .register : .login
        self.clearFields()
        
    }
    
    func authenticate() {
        let username = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedEmail = formatEmail(username)
        
        switch mode {
        case .login:
            login(username: formattedEmail, password: password)
        case .register:
            register(name: name, username: formattedEmail, password: password)
        }
    }
    
    
    func clearFields() {
        
        self.name = ""
        self.password = ""
        self.confirmPassword = ""
        
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            
            self.user = nil
            print("User wurde abgemeldet!")
            
        } catch {
            DispatchQueue.main.async {
                self.handleAuthError(error as NSError)
            }
        }
    }
    
    
    // MARK: - Private Functions
    
    private func formatEmail(_ username: String) -> String {
        let cleanedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedUsername.contains("@") {
            return cleanedUsername
        } else {
            let validUsername = cleanedUsername.filter { "abcdefghijklmnopqrstuvwxyz0123456789._%+-".contains($0) }
            return "\(validUsername)@mediguard.com"
        }
    }
    
    
    
    
    
}

// MARK: - Private Methods

extension UserViewModel {
    
    private func checkAuth() {
        guard let currentUser = firebaseManager.auth.currentUser else {
            
            print("Not logged in")
            
            return
        }
        
        
        self.fetchUser(with: currentUser.uid)
        
    }
    
    private func createUser(with id: String, name: String) {
        let user = FireUser(id: id, name: name, registeredAt: Date())
        
        do {
            try firebaseManager.database.collection("users").document(id).setData(from: user)
            
            print("User wurde erstellt")
            
        } catch let error {
            
            self.errorMessage = "Fehler beim Speichern des Users: \(error)"
            
        }
    }
    
    private func handleAuthError(_ error: NSError) {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            
            self.authenticationError = .unknownError
            self.errorMessage = "Ein unbekannter Fehler ist aufgetreten: \(error.localizedDescription)"
            print("Unbekannter Fehler: \(error.localizedDescription)")
            
            return
        }
        
        
        print("Auth Error Code: \(error.code)")
        print("Auth Error Description: \(error.localizedDescription)")
        
        switch errorCode {
        case .wrongPassword, .userNotFound, .invalidCredential:
            self.authenticationError = .invalidEmailOrPassword
            self.errorMessage = AuthenticationError.invalidEmailOrPassword.errorDescription!
        case .invalidEmail:
            self.authenticationError = .invalidEmailOrPassword
            self.errorMessage = AuthenticationError.invalidEmailOrPassword.errorDescription!
        case .emailAlreadyInUse:
            self.authenticationError = .emailAlreadyInUse
            self.errorMessage = AuthenticationError.emailAlreadyInUse.errorDescription!
        case .networkError:
            self.authenticationError = .networkError
            self.errorMessage = AuthenticationError.networkError.errorDescription!
        case .userTokenExpired:
            self.authenticationError = .sessionExpired
            self.errorMessage = AuthenticationError.sessionExpired.errorDescription!
        case .tooManyRequests:
            self.authenticationError = .tooManyRequests
            self.errorMessage = AuthenticationError.tooManyRequests.errorDescription!
        default:
            self.authenticationError = .unknownError
            self.errorMessage = AuthenticationError.unknownError.errorDescription!
            print("Nicht erkannter Fehlercode: \(error.code)")
        }
        
    }
    
    
    
    private func fetchUser(with id: String) {
        firebaseManager.database.collection("users").document(id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                
                self.errorMessage = "Fetching user failed: \(error.localizedDescription)"
                
                return
            }
            
            guard let document = document else {
                
                self.errorMessage = "Dokument existiert nicht!"
                
                return
            }
            
            do {
                let user = try document.data(as: FireUser.self)
                
                self.user = user
                
            } catch {
                
                self.errorMessage = "Dokument ist kein User: \(error.localizedDescription)"
                
            }
        }
    }
}

