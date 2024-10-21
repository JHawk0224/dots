//
//  AchievementViewModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import Foundation
import SwiftUI

class AchievementViewModel: ObservableObject {
    static let instance = AchievementViewModel()
    
    @AppStorage("unlockedAchievements") private var unlockedAchievements = Set<AchievementName>()
    @AppStorage("upgradesEquipped") private var upgradesEquipped = Set<AchievementName>()
    
    func unlock(achievementName: AchievementName) {
        unlockedAchievements.insert(achievementName)
    }
    
    func lock(achievementName: AchievementName) {
        unlockedAchievements.remove(achievementName)
    }
    
    func isUnlocked(achievementName: AchievementName) -> Bool {
        return unlockedAchievements.contains(achievementName)
    }
    
    func equipDefault(achievementName: AchievementName) {
        upgradesEquipped.remove(achievementName)
    }
    
    func equipUpgrade(achievementName: AchievementName) {
        upgradesEquipped.insert(achievementName)
    }
    
    func isEquipped(achievementName: AchievementName) -> Bool {
        return upgradesEquipped.contains(achievementName)
    }
    
    func restoreDefaults() {
        upgradesEquipped.removeAll()
    }
}
