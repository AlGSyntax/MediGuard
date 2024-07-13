//
//  SwiftUIView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI



struct DrinksAdministrationCostumButton: View {
    var text: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.blue)

                HStack {
                    Text(text)
                        .foregroundColor(.white)
                    
                    Image(systemName: systemImage)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct DrinksAdministrationCostumButton_Previews: PreviewProvider {
    static var previews: some View {
        DrinksAdministrationCostumButton(text: "Add Intake", systemImage: "plus.app") {}
    }
}
