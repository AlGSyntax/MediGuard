//
//  DetailViewButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import SwiftUI

struct DetailViewButton: View {
    
    var body: some View {
        
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .foregroundColor(.white)
                    
                Text(title)
                    .font(.largeTitle) 
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(24)
        
    }
    
    // MARK: - Variables
    let title: String
    let iconName: String
}

struct DetailViewButton_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewButton(title: "Button",  iconName: "star")
    }
}






