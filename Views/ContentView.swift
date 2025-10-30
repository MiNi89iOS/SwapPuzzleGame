//
//  ContentView.swift
//  Swap Puzzle Game
//
//  Created by Mi Ni on 29/10/2025.
//

import SwiftUI

typealias VoidCallback = () -> Void

struct ContentView: View {
    enum Screen { case menu, settings, game, exited }
    @State private var screen: Screen = .menu
    @State private var rows: Int = 4
    @State private var cols: Int = 4
    @State private var showHint: Bool = true
    @State private var customImage: UIImage? = UIImage(named: "puzzleImage")
    @State private var showImagePicker = false
    
    var body: some View {
        switch screen {
        case .menu:
            VStack(spacing: 24) {
                Text("Swap\nThe Puzzle Game")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)
                Button("Start Game") { screen = .game }
                    .buttonStyle(MainButton())
                Button("Settings") { screen = .settings }
                    .buttonStyle(SecondaryButton())
                Button("Exit") { screen = .exited }
                    .buttonStyle(DestructiveButton())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .settings:
            SettingsView(
                rows: $rows,
                cols: $cols,
                showHint: $showHint,
                customImage: $customImage,
                showImagePicker: $showImagePicker,
                onDone: { screen = .menu }
            )
            
        case .game:
            SlidingPuzzleView(
                rows: rows,
                cols: cols,
                uiImage: customImage,
                showHint: showHint
            ) { screen = .menu }
            
        case .exited:
            VStack {
                Spacer()
                Text("Thanks for playing!").font(.title)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}

