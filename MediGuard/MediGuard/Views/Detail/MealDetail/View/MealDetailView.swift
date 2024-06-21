//
//  MealDetailView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 11.06.24.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var viewModel = MealDetailViewModel()

    @State private var showingAddMealSheet = false
    @State private var showingEditMealSheet = false
    @State private var mealToEdit: Meal?

    var body: some View {
        VStack {
            HStack {
                CustomBackButton()
                Spacer()
                Text("Mahlzeiten")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    showingAddMealSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 20)
            
            List {
                ForEach(["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"], id: \.self) { day in
                    VStack(alignment: .leading) {
                        Text(day)
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(["08:00", "12:00", "16:00", "20:00"], id: \.self) { time in
                            VStack(alignment: .leading) {
                                Text(time)
                                    .font(.headline)
                                    .padding(.top, 5)
                                    .padding(.horizontal, 10)

                                // Filter für intakeTime
                                ForEach(viewModel.meals.filter {
                                    let hourMinute = String(format: "%02d:%02d", $0.intakeTime.hour ?? 0, $0.intakeTime.minute ?? 0)
                                    return $0.day == day && hourMinute == time
                                }) { meal in
                                    MealCardView(meal: meal, onDelete: {
                                        viewModel.deleteMeal(meal, userId: userViewModel.userId ?? "")
                                    }, onEdit: {
                                        mealToEdit = meal
                                        showingEditMealSheet.toggle()
                                    })
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                }

                                // Filter für nextIntakeDate
                                ForEach(viewModel.meals.filter {
                                    guard let nextIntakeDate = $0.nextIntakeDate else { return false }
                                    let hourMinute = String(format: "%02d:%02d", nextIntakeDate.hour ?? 0, nextIntakeDate.minute ?? 0)
                                    let nextDay = getDayString(from: nextIntakeDate.weekday)
                                    return nextDay == day && hourMinute == time
                                }) { meal in
                                    MealCardView(meal: meal, onDelete: {
                                        viewModel.deleteMeal(meal, userId: userViewModel.userId ?? "")
                                    }, onEdit: {
                                        mealToEdit = meal
                                        showingEditMealSheet.toggle()
                                    })
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding([.leading, .trailing, .bottom], 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingAddMealSheet) {
            AddMealSheetView(mealViewModel: viewModel)
                .environmentObject(userViewModel)
        }
        .sheet(item: $mealToEdit) { meal in
            EditMealSheetView(mealViewModel: viewModel, meal: meal)
                .environmentObject(userViewModel)
        }
        .onAppear {
            if let userId = userViewModel.userId {
                viewModel.fetchMeals(userId: userId)
            }
        }
    }

    private func getDayString(from weekday: Int?) -> String? {
        guard let weekday = weekday else { return nil }
        switch weekday {
        case 2: return "Montag"
        case 3: return "Dienstag"
        case 4: return "Mittwoch"
        case 5: return "Donnerstag"
        case 6: return "Freitag"
        case 7: return "Samstag"
        case 1: return "Sonntag"
        default: return nil
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
            .environmentObject(UserViewModel())
    }
}

