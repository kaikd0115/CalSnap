//
//  OCRModel.swift
//  CalSnap
//
//  Created by Kodama Kai on 2025/11/30.
//

import Foundation
import SwiftUI
import Vision
import PhotosUI

class OCRViewModel: ObservableObject {
   
    @Published var extractedText: String = ""
    @Published var selectedImage: UIImage?

    func extractTextFromImage() {
        guard let cgImage = selectedImage?.cgImage else { return }

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("OCR Error:", error)
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let text = observations.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")

            DispatchQueue.main.async {
                self.extractedText = text
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        request.recognitionLanguages = ["ja", "en"]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}
