//
//  CostumAddButton.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import SwiftUI

struct CustomAddButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.blue)
                    .font(.system(size: 24, weight: .bold))
            }
            .padding(40)
        }
    }
}
