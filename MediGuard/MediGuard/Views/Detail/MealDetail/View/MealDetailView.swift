//
//  MealDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct MealDetailView: View {
    var body: some View {
        VStack{Text("Einstellungen")
                .font(.largeTitle)
                .padding(.bottom, 40)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}
