//
//  Color+Theme.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

extension Color {
    // Primary Colors
    static let jungleGreen = Color(red: 45/255, green: 90/255, blue: 39/255)
    static let bananaYellow = Color(red: 255/255, green: 225/255, blue: 53/255)
    static let coconutBrown = Color(red: 139/255, green: 69/255, blue: 19/255)

    // Background Colors
    static let lightJungle = Color(red: 220/255, green: 237/255, blue: 218/255)
    static let skyBlue = Color(red: 135/255, green: 206/255, blue: 235/255)

    // Gradient for backgrounds
    static var jungleGradient: LinearGradient {
        LinearGradient(
            colors: [.skyBlue.opacity(0.3), .lightJungle],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Font {
    static func monkeyTitle() -> Font {
        .system(.largeTitle, design: .rounded, weight: .bold)
    }

    static func monkeyHeadline() -> Font {
        .system(.headline, design: .rounded, weight: .semibold)
    }

    static func monkeyBody() -> Font {
        .system(.body, design: .rounded)
    }

    static func monkeyCaption() -> Font {
        .system(.caption, design: .rounded)
    }
}
