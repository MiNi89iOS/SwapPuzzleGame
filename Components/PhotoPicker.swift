//
//  PhotoPicker.swift
//  Swap Puzzle Game
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var cfg = PHPickerConfiguration()
        cfg.filter = .images; cfg.selectionLimit = 1
        let picker = PHPickerViewController(configuration: cfg)
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ ui: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        init(parent: PhotoPicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController,
                    didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let prov = results.first?.itemProvider,
                  prov.canLoadObject(ofClass: UIImage.self) else { return }
            prov.loadObject(ofClass: UIImage.self) { img, _ in
                DispatchQueue.main.async {
                    self.parent.image = img as? UIImage
                }
            }
        }
    }
}
