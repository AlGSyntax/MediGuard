//
//  EmptyIntakesView.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 08.07.24.
//

import SwiftUI

struct EmptyIntakesView: View {
    var body: some View {
        VStack {
            Image(systemName: "takeoutbag.and.cup.and.straw")
                .font(.system(size: 40))
                .padding(.vertical, 10)
            Text("Noch nichts getrunken heute!")
            Text("Trinke etwas und füge es hier hinzu")
            Image(systemName: "arrow.down")
                .padding()
        }
    }
}

struct EmptyIntakesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyIntakesView()
    }
}
