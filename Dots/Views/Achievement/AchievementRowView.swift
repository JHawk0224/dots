//
//  AchievementView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct AchievementRowView: View {
    @ObservedObject var achievementViewModel = AchievementViewModel.instance
    let achievement: Achievement
    var dotType: DotType {
        Achievement.getDot(for: achievement.name)
    }
    var dot: BaseDot {
        switch dotType {
        case .player:
            return PlayerDot()
        case .enemy:
            return EnemyDot()
        case .hardEnemy:
            return HardEnemyDot()
        }
    }
    var isEquipped: Bool {
        achievementViewModel.isEquipped(achievementName: achievement.name)
    }
    var isLocked: Bool {
        !achievementViewModel.isUnlocked(achievementName: achievement.name)
    }
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    achievementViewModel.equipDefault(achievementName: achievement.name)
                }
            }) {
                Circle()
                    .foregroundStyle(dot.color)
                    .frame(width: 50, height: 50)
            }
            
            if isLocked {
                Image(systemName: "lock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.black)
            } else {
                Button(action: {
                    withAnimation {
                        achievementViewModel.equipUpgrade(achievementName: achievement.name)
                    }
                }) {
                    Image(dot.imageStr)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            
            Text(isLocked ? achievement.lockedMessage : (isEquipped ? achievement.upgradeEquippedMessage : achievement.defaultEquippedMessage))
                .foregroundStyle(.black)
                .font(.system(size: 18))
                .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    AchievementRowView(achievement: Achievement.achievementDict[.menuTap]!)
}
