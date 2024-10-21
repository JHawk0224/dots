//
//  PowerupModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import Foundation
import SwiftUI

enum PowerupType: String, CaseIterable, Hashable, Codable, Equatable {
    case pacman
    case freeze
}

struct Powerup: Identifiable {
    let id = UUID()
    let type: PowerupType
    var imageStr: String
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    
    init(type: PowerupType, imageStr: String? = nil, x: CGFloat = 0, y: CGFloat = 0, size: CGFloat = 20) {
        self.type = type
        self.imageStr = imageStr ?? (type == .pacman ? "Pacman" : "Freeze")
        self.x = x
        self.y = y
        self.size = size
    }
    
    init(type: PowerupType, imageStr: String? = nil, size: CGFloat = 20, boundary: CGSize) {
        self.type = type
        self.imageStr = imageStr ?? (type == .pacman ? "Pacman" : "Freeze")
        self.size = size
        let halfSize = size / 2
        self.x = CGFloat.random(in: halfSize...boundary.width - halfSize)
        self.y = CGFloat.random(in: halfSize...boundary.height - halfSize)
    }
}

extension Powerup {
    static let pacman = Powerup(type: .pacman)
    static let freeze = Powerup(type: .freeze)
}
