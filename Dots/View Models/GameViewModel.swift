//
//  GameViewModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    let achievementViewModel = AchievementViewModel.instance
    @Published var navigationPath = NavigationPath()
    @Published var bannerAchievementName: AchievementName? = nil
    @Published var bannerOffset: CGFloat = -200
    
    @Published var boundary: CGSize
    @Published var gameStarted = false
    @Published var isPaused = false {
        didSet {
            if isPaused {
                stopGameLoop()
            } else {
                startGameLoop()
            }
        }
    }
    
    @Published var player: PlayerDot?
    @Published var square: Square?
    @Published var enemies: [EnemyDot] = []
    @Published var hardEnemies: [HardEnemyDot] = []
    @Published var powerup: Powerup?
    private var powerupTimeRemaining: TimeInterval = 5
    @Published var pacmanMode = false
    @Published var freezeMode = false
    @Published var powerupModeTimeRemaining: TimeInterval = 0
    
    @Published var squaresCollected = 0
    @Published var dotsEaten = 0
    var score: Int {
        squaresCollected + dotsEaten
    }
    @AppStorage("highscore") var highscore = 0
    @AppStorage("previousScore") var previousScore = 0
    
    var lastTapLocation: CGPoint?
    
    private var observersAdded = false
    private var gameTimer: Timer?
    private var lastUpdateTime: TimeInterval = 0
    private let frameRate: TimeInterval = 1.0 / 30.0
    
    init(boundary: CGSize = .zero) {
        self.boundary = boundary
    }
    
    deinit {
        finishGame()
    }
    
    func startGame(initPlayer: Bool = true) {
        if gameStarted {
            finishGame()
        }
        
        let minBoundaryDim = min(boundary.width, boundary.height)
        if minBoundaryDim < 50 {
            // too small to play
            return
        }
        
        squaresCollected = 0
        dotsEaten = 0
        enemies = []
        hardEnemies = []
        if initPlayer {
            player = PlayerDot(boundary: boundary)
            square = Square(boundary: boundary)
        }
        powerup = nil
        powerupTimeRemaining = 5
        pacmanMode = false
        freezeMode = false
        powerupModeTimeRemaining = 0
        
        lastTapLocation = nil
        
        gameStarted = true
        isPaused = false // starts game loop
        if initPlayer {
            addObservers()
        }
    }
    
    func finishGame() {
        highscore = max(highscore, score)
        previousScore = score
        
        removeObservers()
        gameStarted = false
        isPaused = false
        stopGameLoop()
    }
    
    private func computeFrame() {
        if isPaused || !gameStarted {
            return
        }
        
        let currentTime = Date().timeIntervalSinceReferenceDate
        let deltaTime = CGFloat(currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        if let player, let lastTapLocation {
            player.move(to: lastTapLocation, distance: deltaTime * player.speed)
        }
        if !freezeMode {
            for enemy in enemies {
                enemy.move(boundary: boundary, distance: deltaTime * enemy.speed)
            }
            if let player {
                for enemy in hardEnemies {
                    enemy.move(to: CGPoint(x: player.x, y: player.y), distance: deltaTime * player.speed / 2)
                }
            }
        }
        
        if let player {
            if let powerup {
                powerupTimeRemaining -= deltaTime
                if player.testCollision(with: powerup) {
                    self.powerup = nil
                    powerupTimeRemaining = 5
                    switch powerup.type {
                    case .pacman:
                        powerupModeTimeRemaining = 3
                        pacmanMode = true
                    case .freeze:
                        powerupModeTimeRemaining = 5
                        freezeMode = true
                    }
                } else if powerupTimeRemaining <= 0 {
                    self.powerup = nil
                    powerupTimeRemaining = 5
                }
            }
            if let square {
                if player.testCollision(with: square) {
                    squaresCollected += 1
                    player.speed = min(450, player.speed + 10)
                    self.square = Square(boundary: boundary)
                    if powerup == nil && !pacmanMode && !freezeMode {
                        generatePowerup()
                    }
                    
                    checkAchievements()
                    
                    addEnemy()
                    if squaresCollected % 5 == 0 {
                        addHardEnemy()
                    }
                }
            }
            for index in (0..<enemies.count).reversed() {
                let enemy = enemies[index]
                if player.testCollision(with: enemy) {
                    if pacmanMode {
                        dotsEaten += 1
                        checkAchievements()
                        enemies.remove(at: index)
                    } else {
                        finishGame()
                        return
                    }
                }
            }
            for index in (0..<hardEnemies.count).reversed() {
                let enemy = hardEnemies[index]
                if player.testCollision(with: enemy) {
                    if pacmanMode {
                        hardEnemies.remove(at: index)
                    } else {
                        finishGame()
                        return
                    }
                }
            }
        }
        
        if pacmanMode || freezeMode {
            powerupModeTimeRemaining -= deltaTime
            if powerupModeTimeRemaining <= 0 {
                pacmanMode = false
                freezeMode = false
                powerupModeTimeRemaining = 0
            }
        }
    }
    
    private func checkAchievements() {
        if score == 10 && !achievementViewModel.isUnlocked(achievementName: .score10Points) {
            achievementViewModel.unlock(achievementName: .score10Points)
            showBanner(achievementName: .score10Points)
        }
        if score == 20 && !achievementViewModel.isUnlocked(achievementName: .score20Points) {
            achievementViewModel.unlock(achievementName: .score20Points)
            showBanner(achievementName: .score20Points)
        }
    }
    
    func addEnemy() {
        enemies.append(EnemyDot(boundary: boundary))
    }
    
    func addHardEnemy() {
        hardEnemies.append(HardEnemyDot(boundary: boundary))
    }
    
    func generatePowerup() {
        if Int.random(in: 1...10) != 1 {
            return
        }
        let powerupType = PowerupType.allCases.randomElement()!
        powerup = Powerup(type: powerupType, boundary: boundary)
    }
}

extension GameViewModel {
    private func startGameLoop() {
        guard gameTimer == nil else { return }
        lastUpdateTime = Date().timeIntervalSinceReferenceDate
        gameTimer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { [weak self] _ in
            self?.computeFrame()
        }
    }

    private func stopGameLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}

extension GameViewModel {
    @objc private func appWillResignActive() {
        DispatchQueue.main.async {
            self.isPaused = true
            self.lastTapLocation = nil
        }
    }
    
    @objc private func appDidBecomeActive() {
        DispatchQueue.main.async {
            self.lastTapLocation = nil
        }
    }
    
    private func addObservers() {
        if !observersAdded {
            NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            observersAdded = true
        }
    }
    
    private func removeObservers() {
        if observersAdded {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
            observersAdded = false
        }
    }
}

extension GameViewModel {
    func showBanner(achievementName: AchievementName) {
        bannerOffset = -200
        bannerAchievementName = achievementName
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.bannerOffset = -200
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.bannerAchievementName = nil
            }
        }
    }
}
