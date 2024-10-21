//
//  DotModel.swift
//  Dots
//
//  Created by Jordan Hochman on 10/15/24.
//

import Foundation
import SwiftUI

struct Square: Identifiable {
    let id = UUID()
    var color: Color
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    
    init(color: Color = .green, x: CGFloat = 0, y: CGFloat = 0, size: CGFloat = 10) {
        self.color = color
        self.x = x
        self.y = y
        self.size = size
    }
    
    init(color: Color = .green, size: CGFloat = 10, boundary: CGSize) {
        self.color = color
        self.size = size
        let halfSize = size / 2
        self.x = CGFloat.random(in: halfSize...boundary.width - halfSize)
        self.y = CGFloat.random(in: halfSize...boundary.height - halfSize)
    }
}

extension Square {
    static let mock = Square()
}
