//
//  SettingsView.swift
//  Swap Puzzle Game
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @Binding var rows: Int
    @Binding var cols: Int
    @Binding var showHint: Bool
    @Binding var customImage: UIImage?
    
    // Lokalny stan wyboru PhotosPicker
    @State private var pickerItem: PhotosPickerItem? = nil
    
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.title2)
                .padding(.bottom, 20)
            Toggle("Show Preview Hint", isOn: $showHint)
                .padding(.horizontal)
            
            Text("Presets")
            HStack(spacing: 8) {
                ForEach(3...8, id: \.self) { n in
                    Button("\(n)x\(n)") {
                        rows = n; cols = n
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background((rows == n && cols == n) ? Color.blue : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            }
            .padding(.bottom, 16)
            
            Text("Custom Grid")
            HStack(spacing: 8) {
                VStack {
                    Text("Cols")
                    Picker("Cols", selection: $cols) {
                        ForEach(3...8, id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                VStack {
                    Text("Rows")
                    Picker("Rows", selection: $rows) {
                        ForEach(3...8, id: \.self) { Text("\($0)") }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.bottom, 16)
            
            Text("Custom Image")
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text(customImage == nil ? "Choose Image" : "Change Image")
                    .frame(width: 180)
                    .padding()
            }
            .buttonStyle(SecondaryButton())
            
            Spacer()
            
            Button("Done") { onDone() }
                .buttonStyle(MainButton())
        }
        .padding()
        // Gdy użytkownik wybierze element w PhotosPicker
        .onChange(of: pickerItem) { _, newItem in
            guard let item = newItem else { return }
            Task {
                // Pobierz dane i zbuduj UIImage
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    customImage = uiImg
                }
            }
        }
        // Sugestia siatki
        .onChange(of: customImage) {
            guard let img = customImage else { return }
            let suggestion = suggestedGrid(for: img,
                                           defaultRows: rows,
                                           defaultCols: cols)
            rows = suggestion.rows
            cols = suggestion.cols
        }
    }
}

