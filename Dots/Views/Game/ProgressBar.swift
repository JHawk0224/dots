//
//  ProgressBar.swift
//  Dots
//
//  Created by Jordan Hochman on 10/20/24.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let borderWidth: CGFloat = 8
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                    .padding(borderWidth)
                    .background(.black)
                    .frame(width: proxy.size.width, height: 40)
                
                let width = proxy.size.width * progress - 2 * borderWidth
                if width > 0 {
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(width: width, height: 40 - 2 * borderWidth)
                        .offset(x: -proxy.size.width * (1 - progress) / 2)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ProgressBar(progress: 0.25)
}
