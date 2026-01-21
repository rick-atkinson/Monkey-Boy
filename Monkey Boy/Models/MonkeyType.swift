//
//  MonkeyType.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import Foundation

enum MonkeyType: String, CaseIterable, Identifiable {
    case baboon = "Baboon"
    case vervet = "Vervet"
    case capuchin = "Capuchin"
    case squirrelMonkey = "Squirrel Monkey"
    case chimpanzee = "Chimpanzee"
    case howler = "Howler Monkey"
    case spiderMonkey = "Spider Monkey"
    case gorilla = "Gorilla"
    case orangutan = "Orangutan"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .baboon: return "🐒"
        case .vervet: return "🐵"
        case .capuchin: return "🙈"
        case .squirrelMonkey: return "🐿️"
        case .chimpanzee: return "🦍"
        case .howler: return "🙊"
        case .spiderMonkey: return "🕷️"
        case .gorilla: return "🦧"
        case .orangutan: return "🦧"
        }
    }

    var displayName: String { rawValue }

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
}
