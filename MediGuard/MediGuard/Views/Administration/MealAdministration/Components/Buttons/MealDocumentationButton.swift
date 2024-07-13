//
//  MealDocumentationButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.07.24.
//

import SwiftUI

struct MealDocumentationButton: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationLink(destination: MealDocumentationView().environmentObject(userViewModel)) {
            Image(systemName: "clock.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.blue)
                .aspectRatio(contentMode: .fit)
        }
        
    }
}

