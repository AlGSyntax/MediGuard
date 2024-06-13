//
//  EmergencyButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

struct EmergencyCallButton: View {
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(.white)
                Text(title)
                    .font(.largeTitle) 
                    
                    
            }
            .padding()
            .background(Color.red)
            .foregroundStyle(.white)
            .cornerRadius(24)
        }
    }
    
    // MARK: - Variables
    let title: String
    let action: () -> Void
    let iconName: String
}

struct EmergencyCallButton_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyCallButton(title: "Notruf", action: {}, iconName: "phone.fill")
    }
}



