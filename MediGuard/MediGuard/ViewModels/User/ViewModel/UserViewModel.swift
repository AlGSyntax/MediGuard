//
//  MediGuardApp.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//


import Foundation
import FirebaseAuth



/**
 Das `UserViewModel` verwaltet die Benutzer-Authentifizierung und hält den Anwendungszustand bezüglich der Benutzerinformationen.
 
 Diese Klasse implementiert `ObservableObject`, um SwiftUI-Views über Änderungen der Benutzerinformationen zu informieren. Die Authentifizierungsmethoden umfassen Anmeldung, Registrierung und Abmeldung.
 
 - Eigenschaften:
 - `user`: Optionaler `FireUser`, der den aktuell authentifizierten Benutzer darstellt.
 - `mode`: Der aktuelle Authentifizierungsmodus (`login` oder `register`).
 - `name`: Benutzername oder E-Mail-Adresse für die Authentifizierung.
 - `password`: Passwort für die Authentifizierung.
 - `confirmPassword`: Bestätigung des Passworts bei der Registrierung.
 - `errorMessage`: Fehlermeldung bei Authentifizierungsfehlern.
 - `authenticationError`: Optionaler `AuthenticationError`, der spezifische Authentifizierungsfehler beschreibt.
 
 - Computed Properties:
 - `userIsLoggedIn`: Boolescher Wert, der angibt, ob ein Benutzer angemeldet ist.
 - `disableAuthentication`: Boolescher Wert, der angibt, ob die Authentifizierung deaktiviert ist (abhängig vom Modus und den Eingabefeldern).
 - `userId`: Optionaler String, der die UID des aktuell authentifizierten Benutzers enthält.
 - `nameDisplay`: Benutzername des aktuell authentifizierten Benutzers oder ein leerer String.
 
 - Funktionen:
 - `login(username:password:)`: Führt die Benutzeranmeldung durch.
 - `register(name:username:password:)`: Führt die Benutzerregistrierung durch.
 - `switchAuthenticationMode()`: Wechselt zwischen den Authentifizierungsmodi.
 - `authenticate()`: Führt die Authentifizierung basierend auf dem aktuellen Modus aus.
 - `clearFields()`: Leert die Eingabefelder für die Authentifizierung.
 - `logout()`: Meldet den aktuell authentifizierten Benutzer ab.
 - `deleteAccount()`: Löscht den aktuell authentifizierten Benutzer und dessen Daten.
 -
 */
@MainActor
class UserViewModel: ObservableObject {
    
    /// Initialisiert das `UserViewModel` und überprüft den Authentifizierungsstatus.
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
    
    /// Gibt an, ob ein Benutzer angemeldet ist.
    var userIsLoggedIn: Bool {
        user != nil
    }
    
    /// Gibt an, ob die Authentifizierung deaktiviert ist.
    var disableAuthentication: Bool {
        if mode == .register {
            return name.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
        } else {
            return name.isEmpty || password.isEmpty
        }
    }
    
    /// Gibt die UID des aktuell authentifizierten Benutzers zurück.
    var userId: String? {
        firebaseManager.auth.currentUser?.uid
    }
    
    /// Gibt den Benutzernamen des aktuell authentifizierten Benutzers zurück.
    var nameDisplay: String {
        user?.name ?? ""
    }
    
    // MARK: - Functions
    
    /**
     Meldet den Benutzer mit dem angegebenen Benutzernamen und Passwort an.
     
     - Parameters:
     - username: Der Benutzername oder die E-Mail-Adresse.
     - password: Das Passwort.
     */
    
    func login(username: String, password: String) {
        let email = formatEmail(username)
        
        
        // Versucht, den Benutzer mit der angegebenen E-Mail und Passwort anzumelden
        firebaseManager.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                
                self.handleAuthError(error)
                
                return
            }
            
            guard let authResult = authResult else { return }
            
            // Ruft die Benutzerdaten nach erfolgreicher Authentifizierung ab
            self.fetchUser(with: authResult.user.uid)
            
        }
    }
    
    /**
     Registriert einen neuen Benutzer mit dem angegebenen Namen, Benutzernamen und Passwort.
     
     - Parameters:
     - name: Der Name des Benutzers.
     - username: Der Benutzername oder die E-Mail-Adresse.
     - password: Das Passwort.
     */
    
    func register(name: String, username: String, password: String) {
        let email = formatEmail(username)
        
        
        // Versucht, einen neuen Benutzer mit der angegebenen E-Mail und Passwort zu erstellen
        firebaseManager.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                
                self.handleAuthError(error)
                
                return
            }
            
            guard let authResult = authResult else { return }
            
            // Erstellt einen neuen Benutzereintrag in der Firestore-Datenbank
            self.createUser(with: authResult.user.uid, name: name)
            
            // Meldet den neu registrierten Benutzer direkt an
            self.login(username: username, password: password)
            
        }
    }
    
    /**
     Löscht den aktuell authentifizierten Benutzer und dessen Daten.
     */
       func deleteAccount() {
           guard let currentUser = firebaseManager.auth.currentUser else {
               self.errorMessage = "Kein Benutzer angemeldet."
               return
           }
           
           // Löscht das Benutzer-Dokument aus Firestore
           firebaseManager.database.collection("users").document(currentUser.uid).delete { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                   self.errorMessage = "Fehler beim Löschen der Benutzerdaten: \(error.localizedDescription)"
                   return
               }
               
               // Löscht den Benutzer aus Firebase Authentication
               currentUser.delete { error in
                   if let error = error {
                       self.errorMessage = "Fehler beim Löschen des Benutzerkontos: \(error.localizedDescription)"
                   } else {
                       self.user = nil
                       self.errorMessage = "Account erfolgreich gelöscht"
                    print("Benutzerkonto wurde gelöscht!")
                       
                   }
               }
           }
       }
    
    /// Wechselt zwischen den Authentifizierungsmodi (`login` und `register`).
    func switchAuthenticationMode() {
        
        self.mode = self.mode == .login ? .register : .login
        self.clearFields()
        
    }
    
    /// Führt die Authentifizierung basierend auf dem aktuellen Modus aus.
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
    
    /// Leert die Eingabefelder für die Authentifizierung.
    func clearFields() {
        
        self.name = ""
        self.password = ""
        self.confirmPassword = ""
        
    }
    
    /// Meldet den aktuell authentifizierten Benutzer ab.
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
    
    
    /**
     Formatiert den Benutzernamen zu einer E-Mail-Adresse.
     
     - Parameter username: Der Benutzername.
     - Returns: Die formatierte E-Mail-Adresse.
     */
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
    
    /**
     Überprüft den Authentifizierungsstatus des Benutzers und ruft die Benutzerdaten ab, falls angemeldet.
     */
    private func checkAuth() {
        guard let currentUser = firebaseManager.auth.currentUser else {
            
            print("Not logged in")
            
            return
        }
        
        
        self.fetchUser(with: currentUser.uid)
        
    }
    
    /**
     Erstellt einen neuen Benutzer in der Firestore-Datenbank.
     
     - Parameters:
     - id: Die Benutzer-ID.
     - name: Der Name des Benutzers.
     */
    private func createUser(with id: String, name: String) {
        let user = FireUser(id: id, name: name, registeredAt: Date())
        
        do {
            try firebaseManager.database.collection("users").document(id).setData(from: user)
            
            print("User wurde erstellt")
            
        } catch let error {
            
            self.errorMessage = "Fehler beim Speichern des Users: \(error)"
            
        }
    }
    
    /**
     Behandelt Authentifizierungsfehler und setzt entsprechende Fehlermeldungen.
     
     - Parameter error: Der aufgetretene Fehler.
     */
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
    
    
    /**
     Ruft die Benutzerdaten aus der Firestore-Datenbank ab.
     
     - Parameter id: Die Benutzer-ID.
     */
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

