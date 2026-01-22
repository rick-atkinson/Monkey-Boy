//
//  DetectedFace.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/22/26.
//

import Foundation
import CoreGraphics

struct DetectedFace: Identifiable, Equatable {
    let id: UUID
    /// Bounding box in normalized coordinates (0-1), origin at bottom-left (Vision framework convention)
    let boundingBox: CGRect
    /// Whether this face should be transformed into a monkey
    var isSelected: Bool

    init(id: UUID = UUID(), boundingBox: CGRect, isSelected: Bool = true) {
        self.id = id
        self.boundingBox = boundingBox
        self.isSelected = isSelected
    }

    /// Convert Vision framework coordinates (origin bottom-left) to UIKit/SwiftUI coordinates (origin top-left)
    func boundingBoxForDisplay(in imageSize: CGSize) -> CGRect {
        let x = boundingBox.origin.x * imageSize.width
        let y = (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height
        let width = boundingBox.width * imageSize.width
        let height = boundingBox.height * imageSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
