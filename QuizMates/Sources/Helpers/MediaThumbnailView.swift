//
//  MediaThumbnailView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

/*
import SwiftUI

struct MediaThumbnailView: View {
    let item: MediaItem
    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
                    .tint(.secondary)
            } else {
                Color.gray.opacity(0.2)
                    .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        // Swift 6 Task: запускается при появлении, отменяется при исчезновении
        .task(id: item.id) {
            await loadImage()
        }
    }

    private func loadImage() async {
        isLoading = true
        // Вызываем метод актора
        let loadedImage = await ImageLoader.shared.loadAndProcess(from: item.localURL)

        // Обновляем UI в главном потоке (MainActor гарантирован в SwiftUI View)
        self.image = loadedImage
        self.isLoading = false
    }
}
*/
