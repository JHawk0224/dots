//
//  GameView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct GameScreenView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    var gameStarted: Bool {
        gameViewModel.gameStarted
    }
    var showOverlay: Bool {
        gameViewModel.isPaused || !gameStarted
    }
    
    var body: some View {
        ZStack {
            GameView()
            
            if gameViewModel.pacmanMode {
                ProgressBar(progress: gameViewModel.powerupModeTimeRemaining / 3)
            }
            
            if gameViewModel.freezeMode {
                FreezeView(opacity: 0.75 * (gameViewModel.powerupModeTimeRemaining / 5))
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        gameViewModel.isPaused = true
                    }) {
                        Image(systemName: "pause.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .foregroundStyle(.primary)
                    .disabled(showOverlay)
                }
                Spacer()
                HStack {
                    Text("Score: \(gameViewModel.score)")
                        .font(.title2)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("Highscore: \(gameViewModel.highscore)")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
            .padding()
            
            if showOverlay {
                Color.primary
                    .ignoresSafeArea()
                    .opacity(0.25)
                VStack(spacing: 20) {
                    Spacer()
                    Text(gameStarted ? "" : "You Lost!")
                        .font(.title)
                        .frame(width: 250)
                    Button(action: {
                        if gameStarted {
                            gameViewModel.isPaused = false
                        } else {
                            gameViewModel.startGame()
                        }
                    }) {
                        Text(gameStarted ? "Resume Game" : "Start New Game")
                            .font(.title)
                            .padding()
                            .frame(width: 250)
                            .background(.gray)
                            .foregroundStyle(.white)
                    }
                    .opacity(0.95)
                    Button(action: {
                        gameViewModel.finishGame()
                        gameViewModel.navigationPath = NavigationPath()
                    }) {
                        VStack {
                            Text("Main Menu")
                                .font(.title)
                                .foregroundStyle(.white)
                            if gameStarted {
                                Text("(This game will be erased)")
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding()
                        .frame(width: 250)
                        .background(.gray)
                    }
                    .opacity(0.95)
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

#if os(iOS)
#Preview {
    GameScreenView()
        .environmentObject(GameViewModel(boundary: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
}
#endif
