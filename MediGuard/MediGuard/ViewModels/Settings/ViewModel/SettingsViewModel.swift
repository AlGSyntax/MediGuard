//
//  SettingsViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI


class SettingsViewModel: ObservableObject {
    @Published var emergencyContact: String
    
    init() {
        emergencyContact = UserDefaults.standard.string(forKey: "emergencyContact") ?? "112"
    }
    
    func saveEmergencyContact() {
        UserDefaults.standard.set(emergencyContact, forKey: "emergencyContact")
    }
}

