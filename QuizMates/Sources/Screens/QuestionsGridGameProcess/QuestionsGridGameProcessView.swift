//
//  QuestionsGridGameProcessView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessViewDelegate: AnyObject {
    func didTapQuestion(dto: QuestionsGridQuestionDTO)
}

struct QuestionsGridGameProcessView: View {
    @Bindable var viewModel: QuestionsGridGameProcessViewModel
    weak var delegate: QuestionsGridGameProcessViewDelegate?

    private let tileSize: CGFloat = 64

    var body: some View {
        ScrollView(.vertical) {
            ScrollView(.horizontal) {
                Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
                    ForEach(viewModel.topics, id: \.0.id) { tuple in
                        GridRow {
                            Text(tuple.0.name)
                                .foregroundStyle(Color(UIColor.label))
                                .padding(leading: 8, trailing: 16)
                            ForEach(viewModel.prices, id: \.self) { price in
                                if let question = tuple.1.first(where: { $0.price == price }) {
                                    makeQuestionView(question)
                                } else {
                                    makeEmptyQuestionView()
                                }
                            }
                        }
                    }
                }
                .padding(top: 24, leading: 16, bottom: 16, trailing: 16)
            }
            makePlayersView()
                .padding(top: 24, bottom: 16)
        }
    }

    @ViewBuilder
    private func makeEmptyQuestionView() -> some View {
        Color.clear
            .frame(width: tileSize, height: tileSize)
    }

    @ViewBuilder
    private func makeQuestionView(_ question: QuestionsGridQuestionDTO) -> some View {
        Button(
            action: {
                delegate?.didTapQuestion(dto: question)
            },
            label: {
                Color.blue
                    .frame(width: tileSize, height: tileSize)
                    .overlay {
                        Text(question.price.description)
                            .foregroundStyle(Color.white)
                    }
            }
        )
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func makePlayersView() -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 16) {
                ForEach(viewModel.players) { player in
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
                        Color(UIColor.systemGroupedBackground)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(leading: 16, trailing: 16)
        }
    }
}
