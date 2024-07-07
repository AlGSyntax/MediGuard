//
//  ConfettiView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 26.06.24.
//

import SwiftUI

struct ConfettiView: View {
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let totalConfetti = 200
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<totalConfetti, id: \.self) { index in
                    ConfettiPieceView(geometry: geometry)
                }
            }
        }
    }
}

#Preview {
    ConfettiView()
}
