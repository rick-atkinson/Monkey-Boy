//
//  MonkeyTransformService.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import FirebaseAI
import UIKit

actor MonkeyTransformService {
    private let model: GenerativeModel

    init() {
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        self.model = ai.generativeModel(
            modelName: "gemini-3-pro-image-preview",
            generationConfig: GenerationConfig(responseModalities: [.text, .image])
        )
    }

    func transform(
        image: UIImage,
        to monkeyType: MonkeyType,
        selectedFaces: [DetectedFace],
        totalFaces: Int
    ) async throws -> UIImage {
        // Resize and fix orientation before sending
        let processedImage = image.fixedOrientation().resized(maxDimension: 1024)

        // Generate prompt based on face selection
        let prompt = monkeyType.transformPrompt(selectedFaces: selectedFaces, totalFaces: totalFaces)

        let response = try await model.generateContent(processedImage, prompt)

        guard let inlineDataPart = response.inlineDataParts.first else {
            throw TransformationError.noImageReturned
        }

        guard let resultImage = UIImage(data: inlineDataPart.data) else {
            throw TransformationError.invalidImage
        }

        return resultImage
    }
}
