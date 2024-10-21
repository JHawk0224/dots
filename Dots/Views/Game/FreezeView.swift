//
//  DotView.swift
//  Dots
//
//  Created by Jordan Hochman on 10/19/24.
//

import SwiftUI

struct FreezeView: View {
    let opacity: Double
    
    var body: some View {
        Image("Ice")
            .resizable()
            .opacity(opacity)
            .ignoresSafeArea()
    }
}

#Preview {
    FreezeView(opacity: 0.5)
}
