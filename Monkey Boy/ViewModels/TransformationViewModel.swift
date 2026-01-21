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

    private let transformService = MonkeyTransformService()
    private let photoLibraryService = PhotoLibraryService()

    func selectImage(_ image: UIImage) {
        originalImage = image
        transformedImage = nil
        selectedMonkey = nil
        state = .selectingMonkey
    }

    func transform() async {
        guard let image = originalImage, let monkey = selectedMonkey else { return }

        state = .transforming
        errorMessage = nil

        do {
            let result = try await transformService.transform(image: image, to: monkey)
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
    }

    func goBackToSelection() {
        state = .selectingMonkey
        transformedImage = nil
        errorMessage = nil
    }
}
