//
//  Math.swift
//  Swap Puzzle Game
//

import Foundation
import UIKit

func gcd(_ a: Int, _ b: Int) -> Int {
    var x = a
    var y = b
    while y != 0 {
        let temp = y
        y = x % y
        x = temp
    }
    return x
}

/// Zwraca sugerowany układ siatki (rows, cols) dla obrazu.
/// - Parameters:
///   - image: Źródłowy UIImage.
///   - allowed: Dozwolony zakres rozmiaru siatki (domyślnie 3...8).
///   - defaultRows: Domyślna liczba wierszy (używana, gdy kilka wariantów ma identyczną różnicę).
///   - defaultCols: Domyślna liczba kolumn (j.w.).
/// - Returns: Para (rows, cols) najlepiej dopasowana do obrazu.
func suggestedGrid(for image: UIImage,
                   allowed: ClosedRange<Int> = 3...8,
                   defaultRows: Int,
                   defaultCols: Int) -> (rows: Int, cols: Int) {
    // Wymiary w pikselach (ważne dla precyzyjnego gcd)
    let wpx = Int(image.size.width * image.scale)
    let hpx = Int(image.size.height * image.scale)

    // Najpierw spróbuj dokładnego rozkładu
    let g = gcd(max(wpx, 1), max(hpx, 1))
    let cExact = max(wpx / g, 1)
    let rExact = max(hpx / g, 1)
    if allowed.contains(rExact), allowed.contains(cExact) {
        return (rExact, cExact)
    }

    // W przeciwnym razie wybierz najlepsze przybliżenie proporcji
    let aspect = image.size.width / image.size.height
    var best = (rows: defaultRows, cols: defaultCols, diff: CGFloat.infinity)

    for r in allowed {
        for c in allowed {
            let gridAspect = CGFloat(c) / CGFloat(r)
            let d = abs(gridAspect - aspect)
            if d < best.diff {
                best = (r, c, d)
            }
        }
    }
    return (best.rows, best.cols)
}

