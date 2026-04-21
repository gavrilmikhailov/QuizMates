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
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                makeQuestionsGridView()
                Spacer()
            }
            .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                playersView
            }
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 0) {
                    Text(viewModel.title)
                        .font(.title)
                        .fontWeight(.bold)
                    ScrollView(.horizontal) {
                        makeQuestionsGridView()
                    }
                }
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
            }
        )
        .tint(Color(preset: viewModel.cellColor))
        .buttonBorderShape(.roundedRectangle(radius: 0))
        .glassProminentOrPlainButtonStyle()
    }

    @ViewBuilder
    private var playersView: some View {
        if Device.current.isPhone {
            ScrollView(.horizontal) {
                makePlayersRowView(itemSpacing: 8)
                    .padding(leading: 16, trailing: 16)
            }
        } else {
            HStack(alignment: .center, spacing: 0) {
                Spacer(minLength: 0)
                makePlayersRowView(itemSpacing: 16)
                Spacer(minLength: 0)
            }
        }
    }

    @ViewBuilder
    private func makePlayersRowView(itemSpacing: CGFloat) -> some View {
        HStack(alignment: .center, spacing: itemSpacing) {
            ForEach(viewModel.players) { player in
                Text("\(player.emoji)  \(player.name)  \(player.score)")
                    .font(.system(size: viewModel.playerNameFontSize, weight: .regular))
                    .padding(all: 16)
                    .background {
                        Color(UIColor.secondarySystemBackground)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
