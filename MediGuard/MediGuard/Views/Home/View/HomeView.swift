//
//  HomeView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 07.06.24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(homeViewModel.greeting)
                    .font(.largeTitle)
                    .padding(.top, 16)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 200)
                    .overlay(
                        Text("Grafisches Element")
                            .foregroundColor(.white)
                    )
                    .padding(.vertical, 16)
                
                VStack(spacing: 8) {
                    NavigationLink(destination: MedicationDetailView()) {
                        DetailViewButton(title: "Medikamente", iconName: "pills.fill")
                    }
                    
                    NavigationLink(destination: MealDetailView()) {
                        DetailViewButton(title: "Mahlzeiten", iconName: "fork.knife")
                    }
                    
                    NavigationLink(destination: DrinksDetailView()) {
                        DetailViewButton(title: "Getränke", iconName: "cup.and.saucer.fill")
                    }
                }
                .padding()
                
                EmergencyCallButton(title: "Notruf", action: {
                    homeViewModel.callEmergencyContact()
                }, iconName: "phone.fill")
                
                Spacer()
            }
            .padding()
            .onAppear {
                homeViewModel.updateGreeting()
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView()) {
                    SettingsButton()
                }
            )
        }
        .environmentObject(homeViewModel)
        .environmentObject(settingsViewModel)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
            .environmentObject(SettingsViewModel())
    }
}







