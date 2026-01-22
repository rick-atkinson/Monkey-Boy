//
//  TransformationViewModel.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

@Observable
final class TransformationViewModel {
    var state: TransformationState = .idle
    var originalImage: UIImage?
    var transformedImage: UIImage?
    var selectedMonkey: MonkeyType?
    var errorMessage: String?
    var detectedFaces: [DetectedFace] = []
    var isDetectingFaces: Bool = false

    private let transformService = MonkeyTransformService()
    private let photoLibraryService = PhotoLibraryService()
    private let faceDetectionService = FaceDetectionService()

    func selectImage(_ image: UIImage) {
        originalImage = image
        transformedImage = nil
        selectedMonkey = nil
        detectedFaces = []
        state = .selectingMonkey

        // Start face detection in background
        Task {
            await detectFaces(in: image)
        }
    }

    private func detectFaces(in image: UIImage) async {
        isDetectingFaces = true
        do {
            detectedFaces = try await faceDetectionService.detectFaces(in: image)
        } catch {
            // Face detection failure is non-fatal - user can still transform
            print("Face detection failed: \(error.localizedDescription)")
            detectedFaces = []
        }
        isDetectingFaces = false
    }

    func toggleFaceSelection(id: UUID) {
        if let index = detectedFaces.firstIndex(where: { $0.id == id }) {
            detectedFaces[index].isSelected.toggle()
        }
    }

    /// Returns only the faces that are selected for transformation
    var selectedFaces: [DetectedFace] {
        detectedFaces.filter { $0.isSelected }
    }

    func transform() async {
        guard let image = originalImage, let monkey = selectedMonkey else { return }

        state = .transforming
        errorMessage = nil

        do {
            let result = try await transformService.transform(
                image: image,
                to: monkey,
                selectedFaces: selectedFaces,
                totalFaces: detectedFaces.count
            )
            transformedImage = result
            state = .completed
        } catch let error as TransformationError {
            errorMessage = error.errorDescription
            state = .error(error)
        } catch {
            let transformError = TransformationError.networkError(error)
            errorMessage = transformError.errorDescription
            state = .error(transformError)
        }
    }

    func saveToPhotos() async {
        guard let image = transformedImage else { return }

        do {
            try await photoLibraryService.saveImage(image)
        } catch {
            errorMessage = (error as? TransformationError)?.errorDescription ?? error.localizedDescription
        }
    }

    func reset() {
        state = .idle
        originalImage = nil
        transformedImage = nil
        selectedMonkey = nil
        errorMessage = nil
        detectedFaces = []
        isDetectingFaces = false
    }

    func goBackToSelection() {
        state = .selectingMonkey
        transformedImage = nil
        errorMessage = nil
    }
}
