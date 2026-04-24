//
//  GameProcessView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import DeviceKit
import SwiftUI

@MainActor
protocol GameProcessViewDelegate: AnyObject {
    func didTapQuestion(topic: TopicDTO, question: QuestionDTO)
}

struct GameProcessView: View {
    @Bindable var viewModel: GameProcessViewModel
    weak var delegate: GameProcessViewDelegate?

    var body: some View {
        if Device.current.isPad {
            VStack(alignment: .center, spacing: 0) {
                makeQuestionsGridView()
                Spacer()
                playersView
            }
        } else {
            ScrollView(.horizontal) {
                makeQuestionsGridView()
            }
            .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                playersView
            }
        }
    }

    @ViewBuilder
    private func makeQuestionsGridView() -> some View {
        Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(viewModel.topics, id: \.0.id) { tuple in
                GridRow {
                    Text(tuple.0.name)
                        .font(.system(size: viewModel.topicFontSize))
                        .foregroundStyle(Color(UIColor.label))
                        .padding(leading: 8, trailing: 16)
                    ForEach(viewModel.prices, id: \.self) { price in
                        if let question = tuple.1.first(where: { $0.price == price }), !question.isAnswered {
                            makeQuestionView(price: question.price.description) {
                                delegate?.didTapQuestion(topic: tuple.0, question: question)
                            }
                        } else {
                            makeEmptyQuestionView()
                        }
                    }
                }
            }
        }
        .padding(top: 24, leading: 16, bottom: 16, trailing: 16)
    }

    @ViewBuilder
    private func makeEmptyQuestionView() -> some View {
        Color.clear
            .frame(width: viewModel.cellSize, height: viewModel.cellSize)
    }

    @ViewBuilder
    private func makeQuestionView(price: String, action: @escaping @MainActor () -> Void) -> some View {
        Button(
            action: action,
            label: {
                Text(price)
                    .font(.system(size: viewModel.questionFontSize))
                    .foregroundStyle(Color.white)
                    .frame(width: viewModel.cellSize, height: viewModel.cellSize)
                    .background {
                        Color(preset: viewModel.cellColor)
                    }
            }
        )
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var playersView: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 8) {
                ForEach(viewModel.players) { player in
                    Text("\(player.emoji)  \(player.name)  \(player.score)")
                        .font(.system(size: viewModel.playerNameFontSize, weight: .regular))
                        .padding(all: 8)
                        .background {
                            Color(UIColor.secondarySystemBackground)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(leading: 16, bottom: 8, trailing: 16)
        }
    }
}
