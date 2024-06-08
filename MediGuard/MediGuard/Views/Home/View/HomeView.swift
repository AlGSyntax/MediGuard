//
//  HomeView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Willkommen in der HomeView!")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                userViewModel.logout()
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.bottom, 20)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserViewModel())
    }
}

