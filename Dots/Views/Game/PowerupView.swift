//
//  DotView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/19/24.
//

import SwiftUI

struct PowerupView: View {
    let powerup: Powerup
    
    var body: some View {
        Image(powerup.imageStr)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: powerup.size, height: powerup.size)
            .position(x: powerup.x, y: powerup.y)
    }
}

#Preview {
    PowerupView(powerup: Powerup.pacman)
}
