//
//  DetailViewButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

/**
 Die `DetailViewButton`-Struktur ist eine SwiftUI-View-Komponente, die einen Button mit einem Symbol und einem Text darstellt.
 
 Dieser Button wird in der `HomeView` verwendet, um zu verschiedenen Detailansichten zu navigieren.

 - Eigenschaften:
    - `title`: Der Text, der auf dem Button angezeigt wird.
    - `iconName`: Der Name des Symbols, das auf dem Button angezeigt wird.
 */
struct AdministrationViewButton: View {
    
    // MARK: - Variables
    
    let title: String
    let iconName: String
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Symbol auf dem Button
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .foregroundStyle(.white)
                
            // Text auf dem Button
            Text(title)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.blue)
        .foregroundStyle(.white)
        .cornerRadius(24)
    }
}

// MARK: - Vorschau

struct DetailViewButton_Previews: PreviewProvider {
    static var previews: some View {
        AdministrationViewButton(title: "Button", iconName: "star")
    }
}







