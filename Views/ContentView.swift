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
                suggestGrid: suggestGrid,
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
    
    /// Exact-ratio or best-fit grid based on image proportions
    private func suggestGrid() {
        guard let img = customImage else { return }
        let wpx = Int(img.size.width * img.scale)
        let hpx = Int(img.size.height * img.scale)
        let g = gcd(wpx, hpx)
        let cExact = wpx / g
        let rExact = hpx / g
        if (3...8).contains(rExact) && (3...8).contains(cExact) {
            rows = rExact
            cols = cExact
            return
        }
        let aspect = img.size.width / img.size.height
        var best: (r: Int, c: Int, diff: CGFloat) = (rows, cols, .infinity)
        for r in 3...8 {
            for c in 3...8 {
                let gridAspect = CGFloat(c) / CGFloat(r)
                let d = abs(gridAspect - aspect)
                if d < best.diff {
                    best = (r, c, d)
                }
            }
        }
        rows = best.r
        cols = best.c
    }
}

#Preview {
    ContentView()
}
