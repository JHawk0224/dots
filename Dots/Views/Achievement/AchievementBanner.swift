//
//  AchievementBanner.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import SwiftUI

struct AchievementBanner: View {
    let achievementName: AchievementName
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                UnevenRoundedRectangle(bottomLeadingRadius: 25, bottomTrailingRadius: 25)
                    .fill(Color.black.opacity(0.5))
                
                VStack {
                    Spacer()
                    Text("Achievement Unlocked!")
                        .lineLimit(1)
                    Text(achievementName.rawValue)
                        .lineLimit(1)
                }
                .foregroundStyle(.white)
                .font(.title)
                .bold()
                .padding()
            }
            .frame(height: 200)
            .position(x: proxy.size.width / 2, y: 0)
        }
    }
}

#Preview {
    AchievementBanner(achievementName: .menuTap)
}
