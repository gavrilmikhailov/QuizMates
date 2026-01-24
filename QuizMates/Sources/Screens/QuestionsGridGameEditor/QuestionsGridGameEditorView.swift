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
    func didTapEditTopic(topic: QuestionsGridTopicModel)
    func didTapCreateNewQuestion(topic: QuestionsGridTopicModel)
    func didTapEditQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel)
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
                emptyView
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
            ForEach(viewModel.topics) { topic in
                GridRow {
                    Button(
                        action: {
                            delegate?.didTapEditTopic(topic: topic)
                        },
                        label: {
                            Text(topic.name)
                        }
                    )
                    ForEach(topic.questions.sorted(by: { $0.price < $1.price })) { question in
                        Button(
                            action: {
                                delegate?.didTapEditQuestion(question: question, topic: topic)
                            },
                            label: {
                                Text(question.price.description)
                            }
                        )
                    }
                    Button(
                        action: {
                            delegate?.didTapCreateNewQuestion(topic: topic)
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

    private var emptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Нет тем", systemImage: "folder.badge.questionmark")
            },
            description: {
                Text("Вы еще не создали ни одной темы для вопросов")
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
