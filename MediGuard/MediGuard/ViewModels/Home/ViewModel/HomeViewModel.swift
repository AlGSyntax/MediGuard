//
//  HomeViewModel.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI


class HomeViewModel: ObservableObject {
    @Published var greeting: String = ""
    
    init() {
        updateGreeting()
    }
    
    func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            greeting = "Guten Morgen!"
        case 12..<16:
            greeting = "Guten Tag!"
        default:
            greeting = "Guten Abend!"
        }
    }
    
    func callEmergencyContact() {
        let emergencyNumber = UserDefaults.standard.string(forKey: "emergencyContact") ?? "112"
        if let url = URL(string: "tel://\(emergencyNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}



