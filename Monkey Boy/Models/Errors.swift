//
//  Errors.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import Foundation

enum TransformationError: LocalizedError {
    case noImageReturned
    case networkError(Error)
    case invalidImage
    case apiError(String)
    case photoLibraryAccessDenied
    case cameraAccessDenied
    case unknown

    var errorDescription: String? {
        switch self {
        case .noImageReturned:
            return "The monkey transformation didn't return an image. Please try again!"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidImage:
            return "Couldn't process that image. Try a different photo!"
        case .apiError(let message):
            return "API error: \(message)"
        case .photoLibraryAccessDenied:
            return "Please allow access to your photo library in Settings."
        case .cameraAccessDenied:
            return "Please allow camera access in Settings."
        case .unknown:
            return "Something went wrong. Please try again!"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noImageReturned, .invalidImage, .unknown:
            return "Try using a different photo with clearly visible people."
        case .networkError:
            return "Check your internet connection and try again."
        case .apiError:
            return "Please try again in a moment."
        case .photoLibraryAccessDenied, .cameraAccessDenied:
            return "Open Settings > Monkey Boy and enable the required permission."
        }
    }
}
