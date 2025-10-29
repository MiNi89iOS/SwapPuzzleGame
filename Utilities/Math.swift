//
//  Math.swift
//  Swap Puzzle Game
//

import Foundation

func gcd(_ a: Int, _ b: Int) -> Int {
    var x = abs(a), y = abs(b)
    while y != 0 {
        let t = x % y; x = y; y = t
    }
    return x
}
