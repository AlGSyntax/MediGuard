//
//  ConfettiPieceView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 26.06.24.
//
import SwiftUI

struct ConfettiPieceView: View {
    @State private var isAnimating = false
    @State private var startPositionY: CGFloat = 0
    @State private var endPositionY: CGFloat = 0
    @State private var opacity = Double.random(in: 0.6...1.0)
    @State private var startDelay = Double.random(in: 0...8)
    
    var geometry: GeometryProxy
    
    private let animationDuration: Double = 5
    private let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow]
    
    var body: some View {
        Rectangle()
            .foregroundColor(colors.randomElement()!)
            .frame(width: CGFloat.random(in: 5...10), height: CGFloat.random(in: 10...20))
            .rotationEffect(.degrees(Double.random(in: 0...360)))
            .position(x: CGFloat.random(in: 0...geometry.size.width), y: isAnimating ? endPositionY : startPositionY)
            .opacity(opacity)
            .onAppear {
                startPositionY = -50
                endPositionY = geometry.size.height + 50
                withAnimation(Animation.linear(duration: animationDuration).delay(startDelay).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiView()
    }
}
