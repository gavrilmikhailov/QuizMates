//
//  GameProcessQuestionView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import AVKit
import CoreModule
import DeviceKit
import SwiftUI

@MainActor
protocol GameProcessQuestionViewDelegate: AnyObject {
    func didAssignScore(player: PlayerDTO, isAddition: Bool)
}

struct GameProcessQuestionView: View {
    @Bindable var viewModel: GameProcessQuestionViewModel
    weak var delegate: GameProcessQuestionViewDelegate?

    @State private var isAnswerHidden: Bool = true

    var body: some View {
        GeometryReader { geoProxy in
            VStack(alignment: .center, spacing: 0) {
                ScrollView(.vertical) {
                    HStack {
                        Spacer()
                        Text(viewModel.text)
                            .font(.system(size: viewModel.questionFontSize))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(top: 40, bottom: 40)
                    ForEach(viewModel.medias, id: \.fileName) { media in
                        switch media.type {
                        case "photo":
                            if let uiImage = UIImage(data: media.data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: geoProxy.size.width * 0.5, maxHeight: geoProxy.size.height * 0.5)
                            } else {
                                mediaLoadErrorView
                            }
                        case "video":
                            if let url = media.getTemporaryUrl() {
                                GameProcessQuestionVideoPlayerView(
                                    url: url,
                                    width: getVideoPlayerWidth(windowSize: geoProxy.size),
                                    height: getVideoPlayerHeight(windowSize: geoProxy.size)
                                )
                            } else {
                                mediaLoadErrorView
                            }
                        case "audio":
                            if let url = media.getTemporaryUrl() {
                                GameProcessQuestionVideoPlayerView(
                                    url: url,
                                    width: getVideoPlayerWidth(windowSize: geoProxy.size),
                                    height: 150
                                )
                            } else {
                                mediaLoadErrorView
                            }
                        default:
                            mediaLoadErrorView
                        }
                    }
                }

                Spacer()
                answerView
                    .padding(top: 20, leading: 8, bottom: 20, trailing: 8)
                playersView
                    .padding(top: 0, leading: 8, bottom: 8, trailing: 8)
            }
        }
    }

    private var mediaLoadErrorView: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text(Strings.mediaLoadError)
                .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private var answerView: some View {
        HStack {
            Spacer()
            if isAnswerHidden {
                Button(
                    action: {
                        withAnimation {
                            isAnswerHidden = false
                        }
                    },
                    label: {
                        Text(Strings.showAnswer)
                    }
                )
                .buttonStyle(.bordered)
            } else {
                Text(viewModel.answer)
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var playersView: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer(minLength: 0)
            ForEach(viewModel.players) { player in
                Menu(
                    content: {
                        Section("\(player.emoji) \(player.name)") {
                            Button(
                                action: {
                                    delegate?.didAssignScore(player: player, isAddition: false)
                                },
                                label: {
                                    Label("\(Strings.subtractScore) \(viewModel.price)", systemImage: "minus")
                                }
                            )
                            Button(
                                action: {
                                    delegate?.didAssignScore(player: player, isAddition: true)
                                },
                                label: {
                                    Label("\(Strings.addScore) \(viewModel.price)", systemImage: "plus")
                                }
                            )
                        }
                    },
                    label: {
                        Text("\(player.emoji)  \(player.name)  \(player.score)")
                            .font(.system(size: viewModel.playerNameFontSize, weight: .regular))
                            .padding(all: 8)
                            .background {
                                Color(UIColor.secondarySystemBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                )
                .foregroundStyle(.primary)
            }
            Spacer(minLength: 0)
        }
    }

    private func getVideoPlayerWidth(windowSize: CGSize) -> CGFloat {
        if Device.current.isPad {
            let relativeWidth: CGFloat = windowSize.width * 0.6
            let maxWidth: CGFloat = 1000
            return min(relativeWidth, maxWidth)
        } else {
            return windowSize.width * 0.9
        }
    }

    private func getVideoPlayerHeight(windowSize: CGSize) -> CGFloat {
        let width = getVideoPlayerWidth(windowSize: windowSize)
        return width / 16 * 9
    }
}

private struct GameProcessQuestionVideoPlayerView: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    @State private var player: AVPlayer?

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let player {
                AVPlayerView(player: player)
                    .frame(width: width, height: height)
            } else {
                Color.clear
                    .frame(width: width, height: height)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .task {
            player = AVPlayer(url: url)
        }
    }
}
