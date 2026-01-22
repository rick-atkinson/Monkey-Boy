//
//  MonkeyType.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import Foundation
import SwiftUI

enum MonkeyType: String, CaseIterable, Identifiable {
    case chimpanzee = "Chimpanzee"
    case gorilla = "Gorilla"
    case orangutan = "Orangutan"
    case baboon = "Baboon"
    case rhesus = "Rhesus Macaque"
    case capuchin = "Capuchin"
    case mandrill = "Mandrill"
    case goldenMonkey = "Golden Monkey"
    case proboscis = "Proboscis Monkey"

    var id: String { rawValue }

    /// Custom image name for each monkey type (stored in Assets)
    var imageName: String {
        switch self {
        case .chimpanzee: return "monkey_chimp"
        case .gorilla: return "monkey_gorilla"
        case .orangutan: return "monkey_orangutan"
        case .baboon: return "monkey_baboon"
        case .rhesus: return "monkey_rhesus"
        case .capuchin: return "monkey_capuchin"
        case .mandrill: return "monkey_mandrill"
        case .goldenMonkey: return "monkey_golden"
        case .proboscis: return "monkey_proboscis"
        }
    }

    /// Fallback emoji if image not available
    var emoji: String {
        switch self {
        case .chimpanzee: return "🐵"
        case .gorilla: return "🦍"
        case .orangutan: return "🦧"
        case .baboon: return "🐒"
        case .rhesus: return "🙈"
        case .capuchin: return "🙊"
        case .mandrill: return "🎭"
        case .goldenMonkey: return "✨"
        case .proboscis: return "👃"
        }
    }

    var displayName: String { rawValue }

    /// Description for the selection screen
    var shortDescription: String {
        switch self {
        case .chimpanzee: return "Our closest relative"
        case .gorilla: return "Gentle giant"
        case .orangutan: return "Red forest dweller"
        case .baboon: return "African primate"
        case .rhesus: return "Lab famous"
        case .capuchin: return "Smart & curious"
        case .mandrill: return "Colorful face"
        case .goldenMonkey: return "Rare beauty"
        case .proboscis: return "Big nose charm"
        }
    }

    var transformPrompt: String {
        """
        Edit this image to replace every human face with a realistic \(rawValue) face. \
        Keep the exact same photo composition, background, lighting, colors, and clothing. \
        Only change the faces - seamlessly blend a photorealistic \(rawValue) face onto each person. \
        The \(rawValue) face should match the person's head angle and expression. \
        Maintain high image quality and natural lighting. \
        Do not change anything else in the image.
        """
    }

    /// Unique background color for each monkey type icon
    var iconBackgroundColor: Color {
        switch self {
        case .chimpanzee: return Color(red: 0.55, green: 0.35, blue: 0.22) // Warm brown
        case .gorilla: return Color(red: 0.3, green: 0.3, blue: 0.35) // Charcoal grey
        case .orangutan: return Color(red: 0.85, green: 0.45, blue: 0.2) // Orange
        case .baboon: return Color(red: 0.6, green: 0.5, blue: 0.35) // Sandy tan
        case .rhesus: return Color(red: 0.75, green: 0.6, blue: 0.5) // Pinkish tan
        case .capuchin: return Color(red: 0.95, green: 0.9, blue: 0.8) // Cream
        case .mandrill: return Color(red: 0.2, green: 0.4, blue: 0.7) // Blue
        case .goldenMonkey: return Color(red: 0.95, green: 0.75, blue: 0.3) // Golden
        case .proboscis: return Color(red: 0.7, green: 0.5, blue: 0.4) // Reddish brown
        }
    }

    /// Accent/highlight color for each monkey
    var iconAccentColor: Color {
        switch self {
        case .chimpanzee: return Color(red: 0.9, green: 0.75, blue: 0.6) // Light peach
        case .gorilla: return Color(red: 0.7, green: 0.7, blue: 0.75) // Silver
        case .orangutan: return Color(red: 1.0, green: 0.7, blue: 0.5) // Light orange
        case .baboon: return Color(red: 0.85, green: 0.5, blue: 0.5) // Pink muzzle
        case .rhesus: return Color(red: 0.95, green: 0.8, blue: 0.75) // Pale pink
        case .capuchin: return Color(red: 0.4, green: 0.25, blue: 0.15) // Dark brown cap
        case .mandrill: return Color(red: 0.9, green: 0.3, blue: 0.3) // Red
        case .goldenMonkey: return Color(red: 0.3, green: 0.5, blue: 0.8) // Blue face
        case .proboscis: return Color(red: 0.9, green: 0.7, blue: 0.6) // Flesh tone
        }
    }
}
