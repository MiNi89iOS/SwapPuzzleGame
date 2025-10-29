//
//  UIImage+Normalized.swift
//  Swap Puzzle Game
//

import UIKit

extension UIImage {
    /// Returns a new image with orientation fixed to .up
    func normalizedImage() -> UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized ?? self
    }
}
