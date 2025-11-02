//
//  SlidingPuzzleViewModel.swift
//  Swap Puzzle Game
//

import SwiftUI
import AudioToolbox
import Observation

@MainActor
@Observable
final class SlidingPuzzleViewModel {
    // Konfiguracja
    private(set) var rows: Int = 4
    private(set) var cols: Int = 4
    private(set) var sourceImage: UIImage?

    // Stan gry
    var tiles: [Tile] = []
    var moveCount: Int = 0
    var startDate: Date = Date()
    var endDate: Date? = nil
    var showSolvedAlert: Bool = false
    var revealComplete: Bool = false
    var lastTileImage: Image? = nil
    var previewExpanded: Bool = false
    
    var timeString: String {
        let end = endDate ?? Date()
        let sec = Int(end.timeIntervalSince(startDate))
        return String(format: "%02d:%02d", sec/60, sec%60)
    }
    
    func configure(rows: Int, cols: Int, image: UIImage?) {
        self.rows = rows
        self.cols = cols
        self.sourceImage = image
    }
    
    func startGame() {
        guard let raw = sourceImage else { return }
        let img = raw.normalizedImage()
        guard let cg = img.cgImage else { return }
        
        // dopasowanie do proporcji siatki (bazując na szerokości)
        let origWpx = cg.width
        let targetHpx = Int(Double(origWpx) * Double(rows) / Double(cols))
        let sizePt = CGSize(width: CGFloat(origWpx)/img.scale,
                            height: CGFloat(targetHpx)/img.scale)
        let renderer = UIGraphicsImageRenderer(size: sizePt)
        let scaled = renderer.image { _ in
            img.draw(in: CGRect(origin: .zero, size: sizePt))
        }
        guard let scg = scaled.cgImage else { return }
        
        let pw = scg.width / cols
        let ph = scg.height / rows
        
        if let lastCG = scg.cropping(to: CGRect(x: (cols-1)*pw,
                                                y: (rows-1)*ph,
                                                width: pw, height: ph)) {
            lastTileImage = Image(uiImage:
                                    UIImage(cgImage: lastCG,
                                            scale: img.scale,
                                            orientation: img.imageOrientation)
            )
        } else {
            lastTileImage = nil
        }
        previewExpanded = false
        
        var arr: [Tile] = []
        var id = 0
        for r in 0..<rows {
            for c in 0..<cols {
                let isLast = (r == rows-1 && c == cols-1)
                let tileImg: Image? = {
                    guard !isLast,
                          let pieceCG = scg.cropping(to: CGRect(x: c*pw,
                                                                y: r*ph,
                                                                width: pw,
                                                                height: ph))
                    else { return nil }
                    return Image(uiImage:
                                    UIImage(cgImage: pieceCG,
                                            scale: img.scale,
                                            orientation: img.imageOrientation)
                    )
                }()
                arr.append(Tile(id: id, image: tileImg))
                id += 1
            }
        }
        tiles = arr
        tilesShagging()
        
        moveCount = 0
        startDate = Date()
        endDate = nil
        showSolvedAlert = false
    }
    
    var emptyIdx: Int {
        tiles.firstIndex { $0.image == nil } ?? 0
    }
    
    func tilesShagging() {
        // Tasowanie: przesunięcia sąsiadów pustego pola
        for _ in 0..<(rows*cols*100) {
            if let n = randomNeighbor(emptyIdx) {
                tiles.swapAt(n, emptyIdx)
            }
        }
        
        moveCount = 0
        revealComplete = false
        endDate = nil
        startDate = Date()
    }
    
    func randomNeighbor(_ empty: Int) -> Int? {
        let dirs = [(0,1),(0,-1),(1,0),(-1,0)]
        let r = empty / cols, c = empty % cols
        return dirs.compactMap { dr, dc in
            let nr = r + dr, nc = c + dc
            guard (0..<rows).contains(nr), (0..<cols).contains(nc) else { return nil }
            return nr*cols + nc
        }.randomElement()
    }
    
    func isNeighbor(_ i: Int, _ j: Int) -> Bool {
        let r1 = i / cols, c1 = i % cols
        let r2 = j / cols, c2 = j % cols
        return (r1 == r2 && abs(c1-c2)==1) || (c1 == c2 && abs(r1-r2)==1)
    }
    
    func tapTile(at idx: Int) {
        guard !revealComplete else { return }
        guard isNeighbor(idx, emptyIdx) else { return }
        tiles.swapAt(idx, emptyIdx)
        moveCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            if self.tiles.enumerated().allSatisfy({ $0.offset == $0.element.id }) {
                self.victory()
            }
        }
    }
    
    func victory() {
        endDate = Date()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        AudioServicesPlaySystemSound(1016)
        showSolvedAlert = true
    }
}

