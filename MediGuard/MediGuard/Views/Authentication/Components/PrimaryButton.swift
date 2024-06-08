//
//  PrimaryButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

struct PrimaryButton: View {
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .background(Color.blue)
        .cornerRadius(12)
    }
    
    
    
    // MARK: - Variables
    
    let title: String
    let action: () -> Void
    
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Login") { }
    }
}
