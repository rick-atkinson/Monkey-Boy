//
//  FaceOverlayView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/22/26.
//

import SwiftUI

struct FaceOverlayView: View {
    let faces: [DetectedFace]
    let imageSize: CGSize
    let onToggle: (UUID) -> Void

    var body: some View {
        GeometryReader { geometry in
            let displaySize = geometry.size

            ForEach(faces) { face in
                let displayRect = faceRect(for: face, imageSize: imageSize, displaySize: displaySize)

                FaceBox(
                    isSelected: face.isSelected,
                    rect: displayRect,
                    onToggle: { onToggle(face.id) }
                )
            }
        }
    }

    private func faceRect(for face: DetectedFace, imageSize: CGSize, displaySize: CGSize) -> CGRect {
        // Calculate aspect fit scaling
        let imageAspect = imageSize.width / imageSize.height
        let displayAspect = displaySize.width / displaySize.height

        let scale: CGFloat
        let offsetX: CGFloat
        let offsetY: CGFloat

        if imageAspect > displayAspect {
            // Image is wider - fit to width
            scale = displaySize.width / imageSize.width
            offsetX = 0
            offsetY = (displaySize.height - imageSize.height * scale) / 2
        } else {
            // Image is taller - fit to height
            scale = displaySize.height / imageSize.height
            offsetX = (displaySize.width - imageSize.width * scale) / 2
            offsetY = 0
        }

        // Get the bounding box in image coordinates
        let imageRect = face.boundingBoxForDisplay(in: imageSize)

        // Scale and offset to display coordinates
        return CGRect(
            x: imageRect.origin.x * scale + offsetX,
            y: imageRect.origin.y * scale + offsetY,
            width: imageRect.width * scale,
            height: imageRect.height * scale
        )
    }
}

private struct FaceBox: View {
    let isSelected: Bool
    let rect: CGRect
    let onToggle: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Border rectangle
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    isSelected ? Color.green : Color.red,
                    lineWidth: 3
                )
                .frame(width: rect.width, height: rect.height)

            // Toggle badge
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.green : Color.red)
                        .frame(width: 28, height: 28)

                    Image(systemName: isSelected ? "checkmark" : "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .offset(x: 10, y: -10)
        }
        .position(x: rect.midX, y: rect.midY)
    }
}

#Preview {
    let sampleFaces = [
        DetectedFace(boundingBox: CGRect(x: 0.3, y: 0.4, width: 0.2, height: 0.25), isSelected: true),
        DetectedFace(boundingBox: CGRect(x: 0.6, y: 0.35, width: 0.18, height: 0.22), isSelected: false)
    ]

    return ZStack {
        Color.gray.opacity(0.3)
        FaceOverlayView(
            faces: sampleFaces,
            imageSize: CGSize(width: 400, height: 300),
            onToggle: { _ in }
        )
    }
    .frame(width: 300, height: 200)
}
