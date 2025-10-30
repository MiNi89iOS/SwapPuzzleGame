//
//  ExitView.swift
//  Swap Puzzle Game
//
//  Created by Mi Ni on 29/10/2025.
//

import SwiftUI

struct ExitView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Thanks for playing!")
                .font(.title)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ExitView()
}
