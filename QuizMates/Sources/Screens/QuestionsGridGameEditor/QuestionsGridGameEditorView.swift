//
//  QuestionsGridGameEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameEditorViewDelegate: AnyObject {
    func didSumbitNewGameName(name: String)
    func didTapCreateNewTopic()
    func didTapEditTopic(topic: QuestionsGridTopicDTO)
    func didTapDeleteTopic(topic: QuestionsGridTopicDTO)
    func didTapCreateNewQuestion(topic: QuestionsGridTopicDTO)
    func didTapEditQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO)
    func didTapDeleteQuestion(question: QuestionsGridQuestionDTO)
    func didTapCreateNewPlayer()
    func didTapEditPlayer(player: QuestionsGridPlayerDTO)
}

struct QuestionsGridGameEditorView: View {

    @Bindable var viewModel: QuestionsGridGameEditorViewModel
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    weak var delegate: QuestionsGridGameEditorViewDelegate?

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
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleNameEditing(isOn: false)
        }
    }

    private var gameNameView: some View {
        HStack(alignment: .center, spacing: 12) {
            if isEditing {
                TextField("Название игры", text: $viewModel.name)
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
                            Label("Удалить", systemImage: "trash")
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
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                    Button(
                        action: {
                            delegate?.didTapCreateNewQuestion(topic: tuple.0)
                        },
                        label: {
                            Label("Новый вопрос", systemImage: "plus")
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
                        Label("Новая тема", systemImage: "plus")
                    }
                )
            }
        }
    }

    private var gameTopicsEmptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Нет тем", systemImage: "folder.badge.questionmark")
            },
            description: {
                Text("Вы еще не добавили ни одной темы для вопросов")
            },
            actions: {
                Button(
                    action: {
                        delegate?.didTapCreateNewTopic()
                    },
                    label: {
                        Label("Добавить новую тему", systemImage: "plus")
                    }
                )
            }
        )
    }

    private var gamePlayersView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Игроки:")
                .font(.title3)
                .foregroundStyle(.primary)
                .padding(leading: 16, bottom: 8, trailing: 16)
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
                        .padding(top: 4, leading: 16, bottom: 4, trailing: 16)
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
                        Text("Добавить игрока")
                            .font(.title3)
                    }
                }
            )
            .padding(leading: 16, bottom: 8, trailing: 16)
        }
    }

    private var gamePlayersEmptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Нет игроков", systemImage: "person.crop.circle.badge.questionmark")
            },
            description: {
                Text("Вы еще не добавили ни одного игрока")
            },
            actions: {
                Button(
                    action: {
                        delegate?.didTapCreateNewPlayer()
                    },
                    label: {
                        Label("Добавить нового игрока", systemImage: "plus")
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
