//
//  AppIconView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/19/24.
//

import SwiftUI

struct AppIconView: View {
    var backgroundColor: Color = .clear
    var gapScale: CGFloat = 0.8
    var iconScale: CGFloat = 0.8
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let centerX = width / 2
            let centerY = height / 2
            let minDim = min(width, height)
            let size = iconScale * minDim / (2 * gapScale + 1)
            let offset = size * gapScale
            
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                // COLOR ASSETS DON'T WORK HERE
                DotView(dot: PlayerDot(color: Color(hex: "#0000FF"), x: centerX, y: centerY, size: size), equippedOverride: false)

                DotView(dot: EnemyDot(color: Color(hex: "#FF0000"), x: centerX - offset, y: centerY - offset, size: size), equippedOverride: false)
                
                DotView(dot: HardEnemyDot(color: Color(hex: "#434343"), x: centerX + offset, y: centerY - offset, size: size), equippedOverride: false)
                
                DotView(dot: HardEnemyDot(x: centerX - offset, y: centerY + offset, size: size), equippedOverride: true)
                
                DotView(dot: EnemyDot(x: centerX + offset, y: centerY + offset, size: size), equippedOverride: true)
            }
            .frame(width: minDim, height: minDim)
        }
    }
}

@MainActor func exportAppIcon(isClear: Bool) {
    let appIconView = AppIconView(backgroundColor: isClear ? .clear : .white).frame(width: 1024, height: 1024)
    let renderer = ImageRenderer(content: appIconView)
    
    if let uiImage = renderer.uiImage {
        saveImage(image: uiImage, isClear: isClear)
    }
}

func saveImage(image: UIImage, isClear: Bool = false) {
    guard let data = image.pngData() else { return }
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(isClear ? "appIconClear.png" : "appIcon.png")
    
    do {
        try data.write(to: url)
        print("App Icon saved successfully to: \(url)")
    } catch {
        print("Error saving app icon: \(error)")
    }
}

#Preview {
    VStack {
        Button(action: {
            exportAppIcon(isClear: true)
            exportAppIcon(isClear: false)
        }) {
            Text("Export App Icon")
        }
        .buttonStyle(BorderedProminentButtonStyle())
        
        AppIconView()
    }
}
