//
//  QuestionsGridGameProcessQuestionView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import AVKit
import CoreModule
import DeviceKit
import SwiftUI

@MainActor
protocol QuestionsGridGameProcessQuestionViewDelegate: AnyObject {
    func didAssignScore(player: QuestionsGridPlayerDTO, isAddition: Bool)
}

struct QuestionsGridGameProcessQuestionView: View {
    @Bindable var viewModel: QuestionsGridGameProcessQuestionViewModel
    weak var delegate: QuestionsGridGameProcessQuestionViewDelegate?

    @State private var isAnswerHidden: Bool = true
    @State private var scoreAssigningMode: ScoreAssigningMode = .ready

    var body: some View {
        GeometryReader { geoProxy in
            ScrollView(.vertical) {
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(bottom: 40)
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
                    case "video", "audio":
                        if let url = media.getTemporaryUrl() {
                            QuestionsGridGameProcessQuestionViewVideoPlayer(
                                url: url,
                                width: getVideoPlayerWidth(windowSize: geoProxy.size),
                                height: getVideoPlayerHeight(windowSize: geoProxy.size)
                            )
                        } else {
                            mediaLoadErrorView
                        }
                    default:
                        mediaLoadErrorView
                    }
                }
                HStack {
                    Spacer()
                    Text(viewModel.text)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(top: 40, bottom: 40)

                if isAnswerHidden {
                    HStack {
                        Spacer()
                        Button(
                            action: {
                                isAnswerHidden = false
                            },
                            label: {
                                Text("Показать ответ")
                            }
                        )
                        Spacer()
                    }
                    .padding(top: 40, bottom: 40)
                } else {
                    HStack {
                        Spacer()
                        Text(viewModel.answer)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(top: 40, bottom: 40)
                }


                HStack {
                    Spacer()
                    switch scoreAssigningMode {
                    case .hidden:
                        EmptyView()
                    case .ready:
                        Button(
                            action: {
                                scoreAssigningMode = .adding
                            },
                            label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "plus")
                                    Text("Присвоить")
                                        .font(.title3)
                                }
                                .padding(top: 4, leading: 8, bottom: 4, trailing: 8)
                            }
                        )
                        .tint(.green)
                        .buttonStyle(.borderedProminent)
                        Button(
                            action: {
                                scoreAssigningMode = .subtracting
                            },
                            label: {
                                HStack(alignment: .center, spacing: 12) {
                                    Image(systemName: "minus")
                                    Text("Вычесть")
                                        .font(.title3)
                                }
                                .padding(top: 4, leading: 8, bottom: 4, trailing: 8)
                            }
                        )
                        .tint(.red)
                        .buttonStyle(.borderedProminent)
                    case .adding, .subtracting:
                        Button(
                            action: {
                                scoreAssigningMode = .ready
                            },
                            label: {
                                HStack(alignment: .center, spacing: 12) {
                                    Text("Отменить")
                                        .font(.title3)
                                }
                                .padding(top: 4, leading: 8, bottom: 4, trailing: 8)
                            }
                        )
                        .tint(.gray)
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
                .padding(top: 40, bottom: 40)

                playersView
            }
        }
    }

    private var mediaLoadErrorView: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("Не удалось загрузить медиафайл")
                .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private var playersView: some View {
        if Device.current.isPhone {
            VStack(alignment: .leading, spacing: 8) {
                Text("Игроки:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(leading: 16)
                ScrollView(.horizontal) {
                    makePlayersRowView(itemSpacing: 8)
                        .padding(leading: 16, trailing: 16)
                }
            }
        } else {
            VStack(alignment: .center, spacing: 8) {
                HStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Игроки:")
                            .font(.title3)
                            .fontWeight(.bold)
                        makePlayersRowView(itemSpacing: 16)
                    }
                    Spacer(minLength: 0)
                }
            }
            .padding(bottom: 16)
        }
    }

    @ViewBuilder
    private func makePlayersRowView(itemSpacing: CGFloat) -> some View {
        HStack(alignment: .center, spacing: itemSpacing) {
            ForEach(viewModel.players) { player in
                Button(
                    action: {
                        switch scoreAssigningMode {
                        case .hidden, .ready:
                            break
                        case .adding:
                            scoreAssigningMode = .hidden
                            delegate?.didAssignScore(player: player, isAddition: true)
                        case .subtracting:
                            scoreAssigningMode = .hidden
                            delegate?.didAssignScore(player: player, isAddition: false)
                        }
                    },
                    label: {
                        VStack(alignment: .center, spacing: 8) {
                            Text(player.emoji)
                                .font(.system(size: 50, weight: .bold))
                            Text(player.name)
                                .font(.system(size: 16, weight: .medium))
                            Text("\(player.score)")
                                .font(.system(size: 16, weight: .regular))
                        }
                        .padding(all: 16)
                        .background {
                            Color(UIColor.secondarySystemBackground)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                )
                .buttonStyle(.plain)
            }
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

private struct QuestionsGridGameProcessQuestionViewVideoPlayer: View {
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

private enum ScoreAssigningMode {
    case hidden
    case ready
    case adding
    case subtracting
}

// Крестик просто закрывает вопрос
// Галочка закрывает вопрос с isAnswered: true
// На экране есть кнопки Показать ответ, Присвоить, Вычесть (условно)
// Игроки должны быть видны всегда
