//
//  NewGameView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var achievementViewModel = AchievementViewModel.instance
    @State private var enemySpawnTimer: Timer?
    
    var body: some View {
        NavigationStack(path: $gameViewModel.navigationPath) {
            GeometryReader { proxy in
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    
                    ForEach(gameViewModel.enemies) { enemy in
                        DotView(dot: enemy)
                    }
                    
                    VStack(spacing: 16) {
                        Spacer()
                        Spacer()
                        Button(action: {
                            if !achievementViewModel.isUnlocked(achievementName: .menuTap) {
                                achievementViewModel.unlock(achievementName: .menuTap)
                                gameViewModel.showBanner(achievementName: .menuTap)
                            }
                        }) {
                            Text("Dotz")
                                .font(.system(size: 60))
                                .foregroundStyle(Color("TextColor"))
                                .padding(.bottom)
                        }
                        NavigationLink(value: "game", label: {
                            Text("Start New Game")
                                .font(.title2)
                                .padding()
                                .frame(width: 200)
                                .background(.gray)
                                .foregroundStyle(.black)
                        })
                        Text("Highscore: \(gameViewModel.highscore)")
                            .font(.title2)
                            .foregroundStyle(Color("TextColor"))
                        Text("Previous Score: \(gameViewModel.previousScore)")
                            .font(.title2)
                            .foregroundStyle(Color("TextColor"))
                        Spacer()
                        NavigationLink(value: "information", label: {
                            Text("Information")
                                .font(.title2)
                                .padding()
                                .frame(width: 200)
                                .background(.gray)
                                .foregroundStyle(.black)
                        })
                        NavigationLink(value: "achievements", label: {
                            Text("Achievements")
                                .font(.title2)
                                .padding()
                                .frame(width: 200)
                                .background(.gray)
                                .foregroundStyle(.black)
                        })
                        Spacer()
                    }
                }
                .onAppear {
                    spawnEnemies(boundary: proxy.size)
                }
                .onChange(of: proxy.size) { oldValue, newValue in
                    if oldValue == .zero {
                        spawnEnemies(boundary: newValue)
                    }
                }
                .onDisappear {
                    stopEnemySpawnTimer()
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "information":
                    InformationView()
                case "achievements":
                    AchievementView()
                case "game":
                    GameScreenView()
                        .navigationBarBackButtonHidden(true)
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func spawnEnemies(boundary: CGSize) {
        if boundary != .zero {
            gameViewModel.boundary = boundary
            gameViewModel.player = nil
            gameViewModel.square = nil
            gameViewModel.startGame(initPlayer: false)
            gameViewModel.addEnemy()
            startEnemySpawnTimer()
        }
    }
    
    private func startEnemySpawnTimer() {
        stopEnemySpawnTimer()
        enemySpawnTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            if gameViewModel.enemies.count < 12 && gameViewModel.player == nil {
                gameViewModel.addEnemy()
            } else {
                stopEnemySpawnTimer()
            }
        }
    }
    
    private func stopEnemySpawnTimer() {
        enemySpawnTimer?.invalidate()
        enemySpawnTimer = nil
    }
}

#if os(iOS)
#Preview {
    GameView()
        .environmentObject(GameViewModel(boundary: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
}
#endif
