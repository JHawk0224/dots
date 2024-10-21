//
//  AchievementView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct AchievementView: View {
    @ObservedObject var achievementViewModel = AchievementViewModel.instance
    
    var body: some View {
        ZStack {
            Color("AchievementColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ForEach(Achievement.achievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        achievementViewModel.restoreDefaults()
                    }
                }) {
                    Text("Restore Defaults")
                }
            }
        }
    }
}

#Preview {
    AchievementView()
}
