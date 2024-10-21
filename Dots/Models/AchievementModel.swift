//
//  AchievementModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import Foundation
import SwiftUI

enum AchievementName: String, CaseIterable, Hashable, Codable, Equatable {
    case menuTap = "Menu Tap"
    case score10Points = "Score 10 Points"
    case score20Points = "Score 20 Points"
}

struct Achievement: Identifiable, Hashable {
    let name: AchievementName
    var id: String { name.rawValue }
        
    let lockedMessage: String
    let defaultEquippedMessage: String
    let upgradeEquippedMessage: String
}

extension Achievement {
    static let achievementDict: [AchievementName: Achievement] = [
        .menuTap: Achievement(name: .menuTap, lockedMessage: "How is this unlocked?", defaultEquippedMessage: "Blue Player Equipped!", upgradeEquippedMessage: "Special Player Equipped!"),
        .score10Points: Achievement(name: .score10Points, lockedMessage: "Score 10 Points", defaultEquippedMessage: "Red Enemy Equipped!", upgradeEquippedMessage: "Special Enemy Equipped!"),
        .score20Points: Achievement(name: .score20Points, lockedMessage: "Score 20 Points", defaultEquippedMessage: "Grey Trackers Equipped!", upgradeEquippedMessage: "Special Trackers Equipped!")
    ]
    
    static private let dotAchievementMap: [DotType: AchievementName] = [
        .player: .menuTap,
        .enemy: .score10Points,
        .hardEnemy: .score20Points
    ]
    
    static private let achievementDotMap: [AchievementName: DotType] = [
        .menuTap: .player,
        .score10Points: .enemy,
        .score20Points: .hardEnemy
    ]
    
    static let achievements: [Achievement] = AchievementName.allCases.map { Achievement.achievementDict[$0]! }
    
    static subscript(_ name: AchievementName) -> Achievement {
        return achievementDict[name]! // force unwrapping since it's guaranteed to exist
    }

    static subscript(_ dot: DotType) -> AchievementName {
        return dotAchievementMap[dot]! // force unwrapping since it's guaranteed to exist
    }
    
    static func getDot(for name: AchievementName) -> DotType {
        return achievementDotMap[name]! // force unwrapping since it's guaranteed to exist
    }
}
