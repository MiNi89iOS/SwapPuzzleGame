//
//  UIImage+Normalized.swift
//  Swap Puzzle Game
//

import UIKit

extension UIImage {
    /// Returns a new image with orientation fixed to .up
    func normalizedImage() -> UIImage {
        guard imageOrientation != .up else { return self }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let normalized = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return normalized
    }
}
