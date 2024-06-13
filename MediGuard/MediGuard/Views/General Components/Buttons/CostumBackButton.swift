//
//  CostumBackButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .font(.system(size: 24, weight: .bold))
                Text("Zurück")
                    .foregroundColor(.blue)
                    .font(.system(size: 24, weight: .bold)) 
            }
            .padding(40)
            
        }
    }
}


