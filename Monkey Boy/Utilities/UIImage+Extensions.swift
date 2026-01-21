//
//  UIImage+Extensions.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import UIKit

extension UIImage {
    /// Resize image to fit within max dimensions while maintaining aspect ratio
    func resized(maxDimension: CGFloat = 1024) -> UIImage {
        let aspectRatio = size.width / size.height

        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: min(size.width, maxDimension), height: min(size.width, maxDimension) / aspectRatio)
        } else {
            newSize = CGSize(width: min(size.height, maxDimension) * aspectRatio, height: min(size.height, maxDimension))
        }

        // Don't upscale
        if newSize.width >= size.width && newSize.height >= size.height {
            return self
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Convert to JPEG data with specified quality
    func jpegData(compressionQuality: CGFloat = 0.8) -> Data? {
        self.jpegData(compressionQuality: compressionQuality)
    }

    /// Fix image orientation to always be up
    func fixedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
}
