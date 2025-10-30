//
//  SettingsView.swift
//  Swap Puzzle Game
//

import SwiftUI

struct SettingsView: View {
    @Binding var rows: Int
    @Binding var cols: Int
    @Binding var showHint: Bool
    @Binding var customImage: UIImage?
    @Binding var showImagePicker: Bool
    
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
            Button(action: { showImagePicker = true }) {
                Text(customImage == nil ? "Choose Image" : "Change Image")
                    .frame(width: 180)
                    .padding()
            }
            .buttonStyle(SecondaryButton())
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: $customImage)
            }
        }
        .padding()
        .onChange(of: customImage) {
            guard let img = customImage else { return }
            let suggestion = suggestedGrid(for: img,
                                           allowed: 3...8,
                                           defaultRows: rows,
                                           defaultCols: cols)
            rows = suggestion.rows
            cols = suggestion.cols
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Done") { onDone() }
                    .buttonStyle(MainButton())
            }
        }
    }
}

