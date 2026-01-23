//
//  QuestionsGridGamesListViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Observation

@Observable
final class QuestionsGridGamesListViewModel {

    // MARK: - Internal properties

    var viewState: ViewState = .loading
    var games: [QuestionsGridGameModel] = []
}
