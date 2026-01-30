//
//  QuestionsGridMediaPreviewView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 29.01.2026.
//

import AVKit
import SwiftUI

struct QuestionsGridMediaPreviewView: View {
    let url: URL
    let type: String

    var body: some View {
        switch type {
        case "photo":
            QuestionsGridPhotoPreviewView(url: url)
        case "video", "audio":
            QuestionsGridVideoPreviewView(url: url)
        default:
            EmptyView()
        }
    }
}

private struct QuestionsGridVideoPreviewView: View {
    let url: URL
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onAppear {
                setupAndPlayVideo()
            }
            .onDisappear {
                player?.pause()
            }
    }

    private func setupAndPlayVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио сессии: \(error)")
        }
        player = AVPlayer(url: url)
        player?.play()
    }
}

private struct QuestionsGridPhotoPreviewView: View {
    let url: URL

    @State private var uiImage: UIImage? = nil
    @State private var isLoading = true
    @State private var error: Error? = nil

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let uiImage = uiImage {
                ZoomableImageView(image: uiImage)
                    .edgesIgnoringSafeArea(.all)
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Не удалось загрузить изображение")
                        .foregroundColor(.gray)
                }
            }
        }
        .task {
            await loadPhoto()
        }
    }

    private func loadPhoto() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.uiImage = image
                    self.isLoading = false
                }
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
}

private struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5.0 // Максимальный зум (5x)
        scrollView.minimumZoomScale = 1.0 // Минимальный зум (оригинал)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .black

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(imageView)
        context.coordinator.imageView = imageView

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])

        let doubleTapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDoubleTap(_:))
        )
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ZoomableImageView
        var imageView: UIImageView?

        init(_ parent: ZoomableImageView) {
            self.parent = parent
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }

            if scrollView.zoomScale > 1 {
                scrollView.setZoomScale(1, animated: true)
            } else {
                let point = gesture.location(in: scrollView)
                let scrollSize = scrollView.frame.size
                let size = CGSize(width: scrollSize.width / 2.5, height: scrollSize.height / 2.5)
                let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
                scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
            }
        }
    }
}
