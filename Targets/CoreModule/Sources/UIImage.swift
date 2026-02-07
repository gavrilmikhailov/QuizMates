//
//  UIImage.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

public extension UIImage {

    func resizedForThumbnail(to maxDimension: CGFloat = 300.0) -> UIImage? {
        let width = size.width
        let height = size.height

        // Если изображение уже маленькое, не трогаем его
        guard width > maxDimension || height > maxDimension else { return self }

        let aspectRatio = width / height
        var newWidth: CGFloat
        var newHeight: CGFloat

        if width > height {
            newWidth = maxDimension
            newHeight = newWidth / aspectRatio
        } else {
            newHeight = maxDimension
            newWidth = newHeight * aspectRatio
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: newWidth, height: newHeight))
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newHeight)))
        }
    }

    func jpegThumbnailData(compression: CGFloat = 0.7) -> Data? {
        return self.resizedForThumbnail()?.jpegData(compressionQuality: compression)
    }
}
