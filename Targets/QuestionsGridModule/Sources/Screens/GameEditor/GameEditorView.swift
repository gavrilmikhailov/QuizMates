//
//  GameEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol GameEditorViewDelegate: AnyObject {
    func didSumbitNewGameName(name: String)
    func didTapCreateNewTopic()
    func didTapEditTopic(topic: TopicDTO)
    func didTapDeleteTopic(topic: TopicDTO)
    func didTapCreateNewQuestion(topic: TopicDTO)
    func didTapEditQuestion(question: QuestionDTO, topic: TopicDTO)
    func didTapDeleteQuestion(question: QuestionDTO)
    func didTapCreateNewPlayer()
    func didTapEditPlayer(player: PlayerDTO)
    func didTapResetGame()
    func didTapGameResults()
    func didTapStartGame()
}

struct GameEditorView: View {

    @Bindable var viewModel: GameEditorViewModel
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    weak var delegate: GameEditorViewDelegate?

    var body: some View {
        ScrollView(.vertical) {
            gameNameView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)

            if !viewModel.topics.isEmpty {
                gameTopicsView
                    .padding(top: 24, leading: 16, bottom: 0, trailing: 16)
            } else {
                gameTopicsEmptyView
                    .padding(top: 40)
            }
            if !viewModel.players.isEmpty {
                gamePlayersView
                    .padding(top: 24, leading: 16, bottom: 0, trailing: 16)
            } else {
                gamePlayersEmptyView
                    .padding(top: 40)
            }

            actionButtonsView
                .padding(top: 24, leading: 16, bottom: 0, trailing: 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleNameEditing(isOn: false)
        }
    }

    private var gameNameView: some View {
        HStack(alignment: .center, spacing: 12) {
            if isEditing {
                TextField(QuestionsGridModuleStrings.gameName, text: $viewModel.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        toggleNameEditing(isOn: false)
                    }
            } else {
                Text(viewModel.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            if !isEditing {
                Button(
                    action: {
                        toggleNameEditing(isOn: true)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.small)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.label))
                    }
                )
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var gameTopicsView: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer(minLength: 0)
            Grid {
                ForEach(viewModel.topics, id: \.0.id) { tuple in
                    GridRow {
                        Button(
                            action: {
                                delegate?.didTapEditTopic(topic: tuple.0)
                            },
                            label: {
                                Text(tuple.0.name)
                            }
                        )
                        .contextMenu {
                            Button(role: .destructive) {
                                delegate?.didTapDeleteTopic(topic: tuple.0)
                            } label: {
                                Label(QuestionsGridModuleStrings.delete, systemImage: "trash")
                            }
                        }
                        ForEach(tuple.1, id: \.id) { question in
                            Button(
                                action: {
                                    delegate?.didTapEditQuestion(question: question, topic: tuple.0)
                                },
                                label: {
                                    Text(question.price.description)
                                }
                            )
                            .contextMenu {
                                Button(role: .destructive) {
                                    delegate?.didTapDeleteQuestion(question: question)
                                } label: {
                                    Label(QuestionsGridModuleStrings.delete, systemImage: "trash")
                                }
                            }
                        }
                        Button(
                            action: {
                                delegate?.didTapCreateNewQuestion(topic: tuple.0)
                            },
                            label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text(QuestionsGridModuleStrings.newQuestion)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        )
                    }
                    Divider()
                }
                GridRow {
                    Button(
                        action: {
                            delegate?.didTapCreateNewTopic()
                        },
                        label: {
                            HStack {
                                Image(systemName: "plus")
                                Text(QuestionsGridModuleStrings.newTopic)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    )
                }
            }
            Spacer(minLength: 0)
        }
        .padding(top: 8, bottom: 8)
    }

    private var gameTopicsEmptyView: some View {
        ContentUnavailableView(
            label: {
                Label(QuestionsGridModuleStrings.noTopicsTitle, systemImage: "folder.badge.questionmark")
            },
            description: {
                Text(QuestionsGridModuleStrings.noTopicsSubtitle)
            },
            actions: {
                Button(
                    action: {
                        delegate?.didTapCreateNewTopic()
                    },
                    label: {
                        Label(QuestionsGridModuleStrings.noTopicsButton, systemImage: "plus")
                    }
                )
            }
        )
    }

    private var gamePlayersView: some View  {
        VStack(alignment: .leading, spacing: 0) {
            Text(QuestionsGridModuleStrings.players)
                .font(.title3)
                .foregroundStyle(.primary)
                .fontWeight(.bold)
                .padding(bottom: 16)
            ForEach(viewModel.players) { player in
                Button(
                    action: {
                        delegate?.didTapEditPlayer(player: player)
                    },
                    label: {
                        HStack(alignment: .center, spacing: 4) {
                            Text(player.emoji)
                            Text(player.name)
                                .font(.title3)
                            Spacer()
                        }
                        .padding(top: 4, bottom: 4)
                    }
                )
                .contentShape(Rectangle())
                .buttonStyle(.plain)
            }
            Button(
                action: {
                    delegate?.didTapCreateNewPlayer()
                },
                label: {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "person.badge.plus")
                        Text(QuestionsGridModuleStrings.addPlayer)
                            .font(.title3)
                    }
                }
            )
            .padding(top: 16, bottom: 0)
        }
    }

    private var actionButtonsView: some View {
        VStack(alignment: .center, spacing: 16) {
            switch viewModel.progressState {
            case .unableToStart:
                makeStartGameButton(isEnabled: false)
            case .readyToStart:
                makeStartGameButton(isEnabled: true)
            case .inProgress:
                resetProgressButton
                resumeGameButton
            case .finished:
                resetProgressButton
                resultsOfGameButton
            }
        }
    }

    private var resetProgressButton: some View {
        Button(
            action: {
                delegate?.didTapResetGame()
            },
            label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "repeat")
                    Text(QuestionsGridModuleStrings.resetProgress)
                        .font(.title3)
                }
                .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
            }
        )
        .tint(.gray)
        .buttonBorderShape(.capsule)
        .glassProminentOrPlainButtonStyle()
    }

    private var resumeGameButton: some View {
        Button(
            action: {
                delegate?.didTapStartGame()
            },
            label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "play.fill")
                    Text(QuestionsGridModuleStrings.resumeGame)
                        .font(.title3)
                }
                .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
            }
        )
        .tint(.blue)
        .buttonBorderShape(.capsule)
        .glassProminentOrPlainButtonStyle()
    }

    private var resultsOfGameButton: some View {
        Button(
            action: {
                delegate?.didTapGameResults()
            },
            label: {
                HStack(alignment: .center, spacing: 12) {
                    Text(QuestionsGridModuleStrings.showResults)
                        .font(.title3)
                }
                .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
            }
        )
        .tint(.blue)
        .buttonBorderShape(.capsule)
        .glassProminentOrPlainButtonStyle()
    }

    private func makeStartGameButton(isEnabled: Bool) -> some View {
        Button(
            action: {
                delegate?.didTapStartGame()
            },
            label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "play.fill")
                    Text(QuestionsGridModuleStrings.startGame)
                        .font(.title3)
                }
                .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
            }
        )
        .tint(.blue)
        .buttonBorderShape(.capsule)
        .glassProminentOrPlainButtonStyle()
        .disabled(!isEnabled)
    }

    private var gamePlayersEmptyView: some View {
        ContentUnavailableView(
            label: {
                Label(QuestionsGridModuleStrings.noPlayersTitle, systemImage: "person.crop.circle.badge.questionmark")
            },
            description: {
                Text(QuestionsGridModuleStrings.noPlayersSubtitle)
            },
            actions: {
                Button(
                    action: {
                        delegate?.didTapCreateNewPlayer()
                    },
                    label: {
                        Label(QuestionsGridModuleStrings.noPlayersAction, systemImage: "plus")
                    }
                )
            }
        )
    }

    private func toggleNameEditing(isOn: Bool) {
        if isOn {
            withAnimation(.spring()) {
                isEditing = true
                isFocused = true
            }
            Task {
                try? await Task.sleep(for: .milliseconds(50))
                UIApplication.shared.sendAction(
                    #selector(UIResponder.selectAll(_:)),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        } else {
            withAnimation(.spring()) {
                isEditing = false
                isFocused = false
            }
            delegate?.didSumbitNewGameName(name: viewModel.name)
        }
    }
}
