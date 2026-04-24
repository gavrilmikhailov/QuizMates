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

    @State private var isAttachmentsHidden: Bool = true
    @State private var isAnswerHidden: Bool = true

    var body: some View {
        GeometryReader { geoProxy in
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    Text(viewModel.text)
                        .font(.system(size: viewModel.questionFontSize))
                        .fontWeight(.bold)
                    Spacer()
                }

                if !viewModel.medias.isEmpty {
                    if isAttachmentsHidden {
                        showAttachmentsButton
                            .padding(top: 40)
                    } else {
                        if viewModel.medias.count == 1, let first = viewModel.medias.first {
                            HStack {
                                Spacer()
                                makeAttachmentView(geoProxy: geoProxy, media: first)
                                Spacer()
                            }
                            .padding(top: 16, leading: 16, trailing: 16)
                        } else {
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: 16) {
                                    ForEach(viewModel.medias, id: \.fileName) { media in
                                        makeAttachmentView(geoProxy: geoProxy, media: media)
                                    }
                                }
                                .padding(top: 16, leading: 16, trailing: 16)
                            }
                            .scrollIndicators(.never)
                        }
                    }
                }

                Spacer()

                GameProcessQuestionAnswerView(isHidden: $isAnswerHidden, answer: viewModel.answer)
                    .padding(top: 16, leading: 8, bottom: 16, trailing: 8)

                Spacer()

                GameProcessQuestionPlayersView(
                    price: viewModel.price,
                    playerNameFontSize: viewModel.playerNameFontSize,
                    players: viewModel.players,
                    onSubtract: { player in
                        delegate?.didAssignScore(player: player, isAddition: false)
                    },
                    onAdd: { player in
                        delegate?.didAssignScore(player: player, isAddition: true)
                    }
                )
                .equatable()
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
    private func makeAttachmentView(geoProxy: GeometryProxy, media: MediaPreviewConfiguration) -> some View {
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

    @ViewBuilder
    private var showAttachmentsButton: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    withAnimation {
                        isAttachmentsHidden = false
                    }
                },
                label: {
                    Text("Показать вложения")
                }
            )
            .buttonStyle(.bordered)
            Spacer()
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

private struct GameProcessQuestionAnswerView: View {
    @Binding var isHidden: Bool
    let answer: String

    var body: some View {
        HStack {
            Spacer()
            if isHidden {
                Button(
                    action: {
                        withAnimation {
                            isHidden = false
                        }
                    },
                    label: {
                        Text(Strings.showAnswer)
                    }
                )
                .buttonStyle(.bordered)
            } else {
                Text(answer)
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

private struct GameProcessQuestionPlayersView: View, Equatable {
    let price: Int
    let playerNameFontSize: CGFloat
    let players: [PlayerDTO]
    let onSubtract: (PlayerDTO) -> Void
    let onAdd: (PlayerDTO) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer(minLength: 0)
            ForEach(players) { player in
                Menu(
                    content: {
                        Section("\(player.emoji) \(player.name)") {
                            Button(
                                action: {
                                    onSubtract(player)
                                },
                                label: {
                                    Label("\(Strings.subtractScore) \(price)", systemImage: "minus")
                                }
                            )
                            Button(
                                action: {
                                    onAdd(player)
                                },
                                label: {
                                    Label("\(Strings.addScore) \(price)", systemImage: "plus")
                                }
                            )
                        }
                    },
                    label: {
                        Text("\(player.emoji)  \(player.name)  \(player.score)")
                            .font(.system(size: playerNameFontSize, weight: .regular))
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

    static func == (lhs: GameProcessQuestionPlayersView, rhs: GameProcessQuestionPlayersView) -> Bool {
        return lhs.price == rhs.price && lhs.playerNameFontSize == rhs.playerNameFontSize && lhs.players == rhs.players
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
