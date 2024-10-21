//
//  DotsApp.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

@main
struct DotsApp: App {
    @StateObject var gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                WelcomeView()
                    .environmentObject(gameViewModel)
                
                if let achievementName = gameViewModel.bannerAchievementName {
                    AchievementBanner(achievementName: achievementName)
                        .offset(y: gameViewModel.bannerOffset)
                        .onAppear {
                            withAnimation {
                                gameViewModel.bannerOffset = 0
                            }
                        }
                        .animation(.linear(duration: 1), value: gameViewModel.bannerOffset)
                }
            }
        }
    }
}
