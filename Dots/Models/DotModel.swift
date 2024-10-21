//
//  DotModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import Foundation
import SwiftUI

enum Direction: String, CaseIterable, Hashable, Codable, Equatable {
    case up
    case down
    case left
    case right
}

enum DotType: String, CaseIterable, Hashable, Codable, Equatable {
    case player
    case enemy
    case hardEnemy
}

protocol Dot: Identifiable {
    var id: UUID { get }
    var type: DotType { get }
    var imageStr: String { get set }
    var color: Color { get set }
    var x: CGFloat { get set }
    var y: CGFloat { get set }
    var size: CGFloat { get set }
    var speed: CGFloat { get set }

    func move(to target: CGPoint, distance: CGFloat?)
    func testCollision(with other: any Dot) -> Bool
    func testCollision(with square: Square) -> Bool
    func testCollision(with powerup: Powerup) -> Bool
}

class BaseDot: ObservableObject, Dot {
    let id = UUID()
    let type: DotType
    var imageStr: String
    var color: Color
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var size: CGFloat
    var speed: CGFloat

    init(type: DotType, imageStr: String = "PlayerUpgrade", color: Color = Color("TrueBlue"), x: CGFloat = 0, y: CGFloat = 0, size: CGFloat = 20, speed: CGFloat = 30) {
        self.type = type
        self.imageStr = imageStr
        self.color = color
        self.x = x
        self.y = y
        self.size = size
        self.speed = speed
    }
    
    init(type: DotType, imageStr: String = "PlayerUpgrade", color: Color = Color("TrueBlue"), size: CGFloat = 20, speed: CGFloat = 30, direction: Direction? = nil, boundary: CGSize) {
        self.type = type
        self.imageStr = imageStr
        self.color = color
        self.size = size
        self.speed = speed
        
        let spawnSide = direction ?? Direction.allCases.randomElement()!
        switch spawnSide {
        case .up:
            self.x = CGFloat.random(in: 0...boundary.width)
            self.y = boundary.height + size / 2
        case .down:
            self.x = CGFloat.random(in: 0...boundary.width)
            self.y = -size / 2
        case .left:
            self.x = boundary.width + size / 2
            self.y = CGFloat.random(in: 0...boundary.height)
        case .right:
            self.x = -size / 2
            self.y = CGFloat.random(in: 0...boundary.height)
        }
    }

    func move(to target: CGPoint, distance: CGFloat? = nil) {
        let distMoved = distance ?? self.speed
        
        let deltaX = target.x - self.x
        let deltaY = target.y - self.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        if distance <= distMoved {
            self.x = target.x
            self.y = target.y
        } else {
            let ratio = distMoved / distance
            self.x += deltaX * ratio
            self.y += deltaY * ratio
        }
    }
    
    func testCollision(with other: any Dot) -> Bool {
        let deltaX = other.x - self.x
        let deltaY = other.y - self.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        return distance <= (self.size + other.size) / 2
    }
    
    func testCollision(with square: Square) -> Bool {
        let circleX = self.x
        let circleY = self.y
        let radius = self.size / 2

        let halfSize = square.size / 2
        let rectLeft = square.x - halfSize
        let rectRight = square.x + halfSize
        let rectTop = square.y - halfSize
        let rectBottom = square.y + halfSize

        let closestX = min(max(circleX, rectLeft), rectRight)
        let closestY = min(max(circleY, rectTop), rectBottom)

        let deltaX = circleX - closestX
        let deltaY = circleY - closestY
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)

        return distance <= radius
    }
    
    func testCollision(with powerup: Powerup) -> Bool {
        let deltaX = powerup.x - self.x
        let deltaY = powerup.y - self.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        return distance <= (self.size + powerup.size) / 2
    }
}

class PlayerDot: BaseDot {
    init(imageStr: String = "PlayerUpgrade", color: Color = Color("TrueBlue"), x: CGFloat = 0, y: CGFloat = 0, size: CGFloat = 40, speed: CGFloat = 150) {
        super.init(type: .player, imageStr: imageStr, color: color, x: x, y: y, size: size, speed: speed)
    }
    
    init(imageStr: String = "PlayerUpgrade", color: Color = Color("TrueBlue"), size: CGFloat = 40, speed: CGFloat = 150, boundary: CGSize) {
        super.init(type: .player, imageStr: imageStr, color: color, x: boundary.width / 2, y: boundary.height / 2, size: size, speed: speed)
    }
}

class EnemyDot: BaseDot {
    var direction: Direction
    
    init(imageStr: String = "SpecialEnemy", color: Color = Color("TrueRed"), x: CGFloat? = nil, y: CGFloat? = nil, size: CGFloat = 20, speed: CGFloat = 30, boundary: CGSize? = nil) {
        self.direction = Direction.allCases.randomElement()!
        if let boundary {
            super.init(type: .enemy, imageStr: imageStr, color: color, size: size, speed: speed, direction: direction, boundary: boundary)
        } else {
            super.init(type: .enemy, imageStr: imageStr, color: color, x: x ?? 0, y: y ?? 0, size: size, speed: speed)
        }
    }

    func move(boundary: CGSize, distance: CGFloat?) {
        let distMoved = distance ?? self.speed
        
        switch direction {
        case .up:
            self.y -= distMoved
            if self.y < 0 {
                self.y = -self.y
                self.direction = .down
            }
        case .down:
            self.y += distMoved
            if self.y > boundary.height {
                self.y = 2 * boundary.height - self.y
                self.direction = .up
            }
        case .left:
            self.x -= distMoved
            if self.x < 0 {
                self.x = -self.x
                self.direction = .right
            }
        case .right:
            self.x += distMoved
            if self.x > boundary.width {
                self.x = 2 * boundary.width - self.x
                self.direction = .left
            }
        }
    }
}

class HardEnemyDot: BaseDot {
    init(imageStr: String = "SpecialHardEnemy", color: Color = Color("HardEnemyColor"), x: CGFloat = 0, y: CGFloat = 0, size: CGFloat = 25, speed: CGFloat = 75) {
        super.init(type: .hardEnemy, imageStr: imageStr, color: color, x: x, y: y, size: size, speed: speed)
    }
    
    init(imageStr: String = "SpecialHardEnemy", color: Color = Color("HardEnemyColor"), size: CGFloat = 25, speed: CGFloat = 75, boundary: CGSize) {
        super.init(type: .hardEnemy, imageStr: imageStr, color: color, size: size, speed: speed, boundary: boundary)
    }
}

extension BaseDot {
    static let mock = BaseDot(type: .player)
}
