//
//  RainDropView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 26.06.24.
//

import SwiftUI

struct RaindropView: View {
    @State private var isAnimating = false
    @State private var startPositionY: CGFloat = 0
    @State private var endPositionY: CGFloat = 0
    @State private var opacity = Double.random(in: 0.2...0.5)
    @State private var startDelay = Double.random(in: 0...8)
    
    var geometry: GeometryProxy
    
    private let animationDuration: Double = 5
    
    var body: some View {
        Circle()
            .foregroundColor(.blue)
            .frame(width: CGFloat.random(in: 3...6), height: CGFloat.random(in: 10...20))
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

struct RainView_Previews: PreviewProvider {
    static var previews: some View {
        RainView()
    }
}


