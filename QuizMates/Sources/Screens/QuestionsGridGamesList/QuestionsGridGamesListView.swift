//
//  QuestionsGridGamesListView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftUI

protocol QuestionsGridGamesListViewDelegate: AnyObject {
    func didTapCreateNewGame()
}

struct QuestionsGridGamesListView: View {

    @Bindable var viewModel: QuestionsGridGamesListViewModel

    weak var delegate: QuestionsGridGamesListViewDelegate?

    var body: some View {
        switch viewModel.viewState {
        case .loading:
            loadingView
        case .normal:
            if !viewModel.games.isEmpty {
                ScrollView(.vertical) {
                    ForEach(viewModel.games) { game in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(game.name)
                            Text(game.createdAt.description)
                        }
                    }
                }
            } else {
                emptyView
            }
        case .error(let errorText):
            Text(errorText)
        }
    }

    private var loadingView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerView()
                .frame(height: 40)
                .clipShape(.rect(cornerRadius: 8))
            ShimmerView()
                .frame(height: 40)
                .clipShape(.rect(cornerRadius: 8))
            ShimmerView()
                .frame(height: 40)
                .clipShape(.rect(cornerRadius: 8))
            Spacer()
        }
        .padding(top: 16, leading: 8, bottom: 0, trailing: 8)
    }

    private var emptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Нет игр", systemImage: "square.grid.3x2")
            },
            description: {
                Text("Вы еще не создали ни одной игры")
            },
            actions: {
                Button(
                    action: {
                        delegate?.didTapCreateNewGame()
                    },
                    label: {
                        Label("Создать новую игру", systemImage: "plus")
                    }
                )
            }
        )
    }
}
