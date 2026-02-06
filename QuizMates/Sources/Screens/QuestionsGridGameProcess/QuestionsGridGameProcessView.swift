//
//  QuestionsGridGameProcessView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import DeviceKit
import SwiftUI

@MainActor
protocol QuestionsGridGameProcessViewDelegate: AnyObject {
    func didTapQuestion(topic: QuestionsGridTopicDTO, question: QuestionsGridQuestionDTO)
}

struct QuestionsGridGameProcessView: View {
    @Bindable var viewModel: QuestionsGridGameProcessViewModel
    weak var delegate: QuestionsGridGameProcessViewDelegate?

    private let tileSize: CGFloat = 64

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
            .frame(width: tileSize, height: tileSize)
    }

    @ViewBuilder
    private func makeQuestionView(price: String, action: @escaping @MainActor () -> Void) -> some View {
        Button(
            action: action,
            label: {
                Color.blue
                    .frame(width: tileSize, height: tileSize)
                    .overlay {
                        Text(price)
                            .foregroundStyle(Color.white)
                    }
            }
        )
        .buttonStyle(.plain)
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
        }
    }
}
