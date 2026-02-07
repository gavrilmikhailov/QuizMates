//
//  AVPlayerView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 05.02.2026.
//

import AVKit
import SwiftUI

public struct AVPlayerView: UIViewControllerRepresentable {
    private let player: AVPlayer

    public init(player: AVPlayer) {
        self.player = player
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        return controller
    }

    public func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    }

    public class Coordinator: NSObject {
        var parent: AVPlayerView

        init(_ parent: AVPlayerView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: parent.player.currentItem
            )
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        @objc
        private func playerDidFinishPlaying() {
            parent.player.seek(to: .zero)
            parent.player.play()
        }
    }
}
