//
//  ContentView.swift
//  Swap Puzzle Game
//
//  Created by Mi Ni on 29/10/2025.
//

import SwiftUI
import Observation

typealias VoidCallback = () -> Void

struct ContentView: View {
    enum Screen { case menu, settings, game }
    @State private var screen: Screen = .menu
    @State private var rows: Int = 4
    @State private var cols: Int = 4
    @State private var showHint: Bool = true
    @State private var customImage: UIImage? = UIImage(named: "puzzleImage")
    
    // Wspólny ViewModel wstrzykiwany przez środowisko do ekranu gry
    @State private var gameViewModel = SlidingPuzzleViewModel()
    
    var body: some View {
        switch screen {
        case .menu:
            MenuView(
                onStart: { screen = .game },
                onSettings: { screen = .settings }
            )
            
        case .settings:
            SettingsView(
                rows: $rows,
                cols: $cols,
                showHint: $showHint,
                customImage: $customImage,
                onDone: { screen = .menu }
            )
            
        case .game:
            SlidingPuzzleView(
                rows: rows,
                cols: cols,
                uiImage: customImage,
                showHint: showHint
            ) { screen = .menu }
            .environment(gameViewModel)
        }
    }
}

#Preview {
    ContentView()
}

