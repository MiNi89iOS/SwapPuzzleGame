//
//  MenuView.swift
//  Swap Puzzle Game
//

import SwiftUI

struct MenuView: View {
    var onStart: () -> Void
    var onSettings: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Swap\nThe Puzzle Game")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
            Button("Start Game") { onStart() }
                .buttonStyle(MainButton())
            Button("Settings") { onSettings() }
                .buttonStyle(SecondaryButton())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MenuView(onStart: {}, onSettings: {})
}

