//
//  SectionModifier.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 14.07.24.
//

import SwiftUI

// MARK: - Custom Modifier for Section

extension View {
    /**
     Ein benutzerdefinierter Modifier, der den Sections mehr Größe verleiht und ihnen einen Corner-Radius hinzufügt.
     
     - Returns: Eine modifizierte Ansicht mit zusätzlicher Größe, Hintergrundfarbe und Corner-Radius.
     */
    func customSectionStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
            
           
    }
}

