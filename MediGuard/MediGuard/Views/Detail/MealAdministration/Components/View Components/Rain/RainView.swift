//
//  RainView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 26.06.24.
//

import SwiftUI

struct RainView: View {
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let totalRaindrops = 400
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<totalRaindrops, id: \.self) { index in
                    RaindropView(geometry: geometry)
                }
            }
        }
    }
}

#Preview {
    RainView()
}
