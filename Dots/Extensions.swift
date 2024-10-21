//
//  Extensions.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import Foundation
import SwiftUI

extension Dictionary: @retroactive RawRepresentable where Key: Codable, Value: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        do {
            self = try JSONDecoder().decode([Key: Value].self, from: data)
        } catch {
            return nil
        }
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return result
    }
}

extension Set: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        do {
            self = try JSONDecoder().decode(Set<Element>.self, from: data)
        } catch {
            return nil
        }
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension RangeReplaceableCollection where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        do {
            let decodedArray = try JSONDecoder().decode([Element].self, from: data)
            self.init(decodedArray)
        } catch {
            return nil
        }
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(Array(self)),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension MutableCollection where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }

        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}

extension Collection {
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }

    var random: Iterator.Element? {
        return shuffle().first
    }
}

extension LazyMapCollection {
    func toArray() -> [Element] {
        return Array(self)
    }
}

extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: T.self) { group in
            forEach { element in
                group.addTask {
                    try await transform(element)
                }
            }

            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
}

extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255)
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).uppercased()
        
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit, e.g., "F0A")
            (a, r, g, b) = (
                255,
                ((int >> 8) & 0xF) * 17,
                ((int >> 4) & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 4: // ARGB (16-bit, e.g., "1F0A")
            (a, r, g, b) = (
                ((int >> 12) & 0xF) * 17,
                ((int >> 8) & 0xF) * 17,
                ((int >> 4) & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // RRGGBB (24-bit, e.g., "FF00AA")
            (a, r, g, b) = (
                255,
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        case 8: // AARRGGBB (32-bit, e.g., "80FF00AA")
            (a, r, g, b) = (
                (int >> 24) & 0xFF,
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            // Invalid format, default to clear color
            (a, r, g, b) = (0, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//extension Decodable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8) else {
//            return nil
//        }
//        do {
//            self = try JSONDecoder().decode(Self.self, from: data)
//        } catch {
//            return nil
//        }
//    }
//}
//
//extension Encodable {
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
//}

//extension RawRepresentable where Self: Codable, RawValue == String {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8) else {
//            return nil
//        }
//        do {
//            let decoded = try JSONDecoder().decode(Self.self, from: data)
//            self = decoded
//        } catch {
//            return nil
//        }
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return ""
//        }
//        return result
//    }
//}
