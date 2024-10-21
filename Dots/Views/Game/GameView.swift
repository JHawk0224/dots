//
//  GameView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .foregroundStyle(gameViewModel.pacmanMode ? Color.yellow : (colorScheme == .dark ? Color.black : Color.white))
                
                if let square = gameViewModel.square {
                    SquareView(square: square)
                }
                
                if let powerup = gameViewModel.powerup {
                    PowerupView(powerup: powerup)
                }
                
                ForEach(gameViewModel.enemies) { enemy in
                    DotView(dot: enemy)
                }
                
                ForEach(gameViewModel.hardEnemies) { enemy in
                    DotView(dot: enemy)
                }
                
                if let player = gameViewModel.player {
                    DotView(dot: player)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        gameViewModel.lastTapLocation = value.location
                    }
                    .onEnded { _ in
                        gameViewModel.lastTapLocation = nil
                    }
            )
            .onChange(of: proxy.size) {
                gameViewModel.boundary = proxy.size
            }
            .onAppear {
                gameViewModel.boundary = proxy.size
                gameViewModel.startGame()
            }
        }
        .ignoresSafeArea()
    }
}

#if os(iOS)
#Preview {
    GameView()
        .environmentObject(GameViewModel(boundary: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
}
#endif
