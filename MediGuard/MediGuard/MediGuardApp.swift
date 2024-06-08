//
//  MediGuardApp.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI
import Firebase

@main
struct MediGuardApp: App {
    
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if userViewModel.userIsLoggedIn{
                HomeView()
                    .environmentObject(userViewModel)
            }else{
                AuthenticationView()
                    .environmentObject(userViewModel)
            }
            
        }
    }
    
    // MARK: - Variables
        
        @StateObject private var userViewModel = UserViewModel()
}
