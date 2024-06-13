//
//  TextButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//



import SwiftUI

struct TextButton: View {
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                
        }
    }
    
    
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(title: "Anmelden") { }
    }
}
