//
//  SlidingPuzzleView.swift
//  Swap Puzzle Game
//

import SwiftUI

struct SlidingPuzzleView: View {
    @StateObject var viewModel = SlidingPuzzleViewModel()
    let rows: Int
    let cols: Int
    let uiImage: UIImage?
    let showHint: Bool
    var onExit: () -> Void
    
    @Namespace private var previewNS
    @Namespace private var tileNamespace
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let hintW: CGFloat = showHint ? 100 : 0
                let maxW = geo.size.width - hintW - 20
                let maxH = geo.size.height - 60
                let side = min(maxW/CGFloat(cols), maxH/CGFloat(rows))
                
                HStack {
                    if showHint, let hintImg = uiImage {
                        Image(uiImage: hintImg)
                            .resizable().scaledToFit()
                            .frame(width: hintW)
                            .padding(.leading)
                            .matchedGeometryEffect(id: "preview", in: previewNS)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.previewExpanded.toggle()
                                }
                            }
                    }
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Moves: \(viewModel.moveCount)")
                            Spacer()
                            TimelineView(.periodic(from: viewModel.startDate, by: 1)) { _ in
                                Text(viewModel.timeString)
                            }
                        }
                        .padding(.horizontal)
                        
                        ZStack {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.fixed(side), spacing: 0), count: cols),
                                spacing: 0
                            ) {
                                ForEach(Array(viewModel.tiles.enumerated()), id: \.element.id) { idx, t in
                                    ZStack {
                                        if let img = t.image {
                                            img.resizable().scaledToFill()
                                                .frame(width: side, height: side)
                                                .clipped()
                                        } else if viewModel.revealComplete, let last = viewModel.lastTileImage {
                                            last.resizable().scaledToFill()
                                                .frame(width: side, height: side)
                                                .clipped()
                                        } else {
                                            Color.clear.frame(width: side, height: side)
                                        }
                                    }
                                    .border(
                                        (t.image != nil || (viewModel.revealComplete && t.image == nil))
                                        ? Color.black : Color.clear,
                                        width: 1
                                    )
                                    .matchedGeometryEffect(id: t.id, in: tileNamespace)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            viewModel.tapTile(at: idx)
                                        }
                                    }
                                }
                            }
                            .frame(width: side * CGFloat(cols),
                                   height: side * CGFloat(rows))
                            
                            Button("← Menu") { onExit() }
                                .padding(12)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity,
                                       alignment: .topLeading)
                            
                            Button {
                                withAnimation(.spring()) {
                                    viewModel.startGame()
                                }
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity,
                                   alignment: .topTrailing)
                        }
                    }
                }
                .onAppear {
                    viewModel.configure(rows: rows, cols: cols, image: uiImage)
                    viewModel.startGame()
                }
                .alert("Gratulacje!", isPresented: $viewModel.showSolvedAlert) {
                    Button("OK", role: .cancel) { viewModel.revealComplete = true }
                } message: {
                    Text("Ułożyłeś puzzle w \(viewModel.moveCount) ruchach w czasie \(viewModel.timeString)!")
                }
            }
            
            if viewModel.previewExpanded, let fullImg = uiImage {
                Color.black.opacity(0.8).ignoresSafeArea()
                Image(uiImage: fullImg)
                    .resizable().scaledToFit()
                    .matchedGeometryEffect(id: "preview", in: previewNS)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.previewExpanded = false
                        }
                    }
            }
        }
    }
}
