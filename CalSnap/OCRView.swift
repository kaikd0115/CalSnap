//
//  OCRView.swift
//  CalSnap
//
//  Created by Kodama Kai on 2025/11/30.
//

import SwiftUI
import PhotosUI

struct OCRView: View {
    @StateObject private var vm = OCRViewModel()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 20) {

            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text("Choose Image")
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .onChange(of: pickerItem) { oldValue, newValue in
                if let newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            vm.selectedImage = uiImage
                            vm.extractTextFromImage()
                        }
                    }
                }
            }
            if let image = vm.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
            }

            ScrollView {
                Text(vm.extractedText.isEmpty ? "Text will appear here…" : vm.extractedText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    OCRView()
}
