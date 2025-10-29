//
//  ButtonStyles.swift
//  Swap Puzzle Game
//

import SwiftUI

struct MainButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding().frame(width: 200)
            .background(Color.blue).foregroundColor(.white)
            .cornerRadius(8).opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding().frame(width: 200)
            .background(Color.gray).foregroundColor(.white)
            .cornerRadius(8).opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct DestructiveButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding().frame(width: 200)
            .background(Color.red).foregroundColor(.white)
            .cornerRadius(8).opacity(configuration.isPressed ? 0.7 : 1)
    }
}
