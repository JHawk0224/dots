//
//  InformationView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Information")
                .font(.system(size: 50))
            VStack(alignment: .leading, spacing: 20) {
                Text("Contact: If you find any bugs or have suggestions please email me at jhawk111@icloud.com")
                Text("Website: www.thedotzapp.wordpress.com")
                Text("How to play: Drag your finger around the screen as your character follows you and try to avoid the red and grey dots. Every time you collect a green square, another enemy is added, and every 5 squares collected a grey enemy is added. There is a possibility that a powerup will spawn randomly. The freeze powerup freezes the screen while the pacman powerup lets you eat the neemies.")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    InformationView()
}
