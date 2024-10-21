//
//  DotView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/19/24.
//

import SwiftUI

struct DotView: View {
    @ObservedObject var dot: BaseDot
    @ObservedObject var achievementViewModel = AchievementViewModel.instance
    var equippedOverride: Bool? = nil
    var isEquipped: Bool {
        return equippedOverride ?? achievementViewModel.isEquipped(achievementName: Achievement[dot.type])
    }
    
    var body: some View {
        ZStack {
            if isEquipped {
                Image(dot.imageStr)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: dot.size, height: dot.size)
            } else {
                Circle()
                    .foregroundStyle(dot.color)
                    .frame(width: dot.size, height: dot.size)
            }
        }
        .position(x: dot.x, y: dot.y)
    }
}

#Preview {
    @Previewable @StateObject var dot = BaseDot.mock
    DotView(dot: dot)
}
