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

    private static let funnyApiErrors = [
        "The monkeys are on a banana break 🍌",
        "Our monkey artists got distracted by a shiny object",
        "The jungle server is having a wild day",
        "Oops! The monkeys dropped their paintbrushes",
        "The monkey transformation machine ran out of bananas",
        "A chimp accidentally unplugged the server",
        "The monkeys are currently in a union meeting",
        "Our AI monkeys went to get coffee. They'll be back!",
        "The banana-powered servers need more potassium",
        "Even monkeys need a vacation sometimes"
    ]

    var errorDescription: String? {
        switch self {
        case .noImageReturned:
            return "The monkey artists finished but forgot to show us their work! Classic monkeys."
        case .networkError:
            return "Looks like the jungle WiFi is down. Those vines make terrible ethernet cables!"
        case .invalidImage:
            return "Our monkeys are confused by this image. Maybe it's too beautiful for them to handle?"
        case .apiError:
            return Self.funnyApiErrors.randomElement() ?? "The monkeys encountered a mysterious error"
        case .photoLibraryAccessDenied:
            return "The monkeys can't see your photos! They need permission to peek."
        case .cameraAccessDenied:
            return "Camera shy? The monkeys need camera access to work their magic!"
        case .unknown:
            return "Something went bananas! Even our smartest chimp doesn't know what happened."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noImageReturned, .invalidImage, .unknown:
            return "Try using a different photo with clearly visible people."
        case .networkError:
            return "Check your internet connection and try again."
        case .apiError:
            return "Give it another go - the monkeys are ready to try again!"
        case .photoLibraryAccessDenied, .cameraAccessDenied:
            return "Open Settings > Monkey Boy and enable the required permission."
        }
    }
}
