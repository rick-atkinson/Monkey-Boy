//
//  FaceDetectionService.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/22/26.
//

import Vision
import UIKit

enum FaceDetectionError: Error, LocalizedError {
    case invalidImage
    case detectionFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Could not process the image for face detection."
        case .detectionFailed(let error):
            return "Face detection failed: \(error.localizedDescription)"
        }
    }
}

actor FaceDetectionService {
    func detectFaces(in image: UIImage) async throws -> [DetectedFace] {
        guard let cgImage = image.cgImage else {
            throw FaceDetectionError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectFaceRectanglesRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: FaceDetectionError.detectionFailed(error))
                    return
                }

                let faces = (request.results as? [VNFaceObservation] ?? []).map { observation in
                    DetectedFace(
                        id: UUID(),
                        boundingBox: observation.boundingBox,
                        isSelected: true
                    )
                }
                continuation.resume(returning: faces)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: FaceDetectionError.detectionFailed(error))
            }
        }
    }
}
