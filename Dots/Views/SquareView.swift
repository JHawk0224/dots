//
//  DotView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/19/24.
//

import SwiftUI

struct SquareView: View {
    let square: Square
    
    var body: some View {
        Rectangle()
            .foregroundStyle(square.color)
            .frame(width: square.size, height: square.size)
            .position(x: square.x, y: square.y)
    }
}

#Preview {
    SquareView(square: Square.mock)
}
