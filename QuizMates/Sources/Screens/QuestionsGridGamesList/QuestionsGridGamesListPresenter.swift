//
//  QuestionsGridGamesListPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

@MainActor
protocol QuestionsGridGamesListPresenterProtocol: AnyObject {
    func presentGames(result: Result<[QuestionsGridGameModel], Error>)
}

@MainActor
final class QuestionsGridGamesListPresenter: QuestionsGridGamesListPresenterProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGamesListViewControllerProtocol?

    // MARK: - QuestionsGridGamesListPresenterProtocol

    func presentGames(result: Result<[QuestionsGridGameModel], Error>) {
        view?.displayGames(result: result)
    }
}
