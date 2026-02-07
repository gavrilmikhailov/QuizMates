//
//  GamesListPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

@MainActor
protocol GamesListPresenterProtocol: AnyObject {
    func presentGames(result: Result<[GameDTO], Error>)
}

@MainActor
final class GamesListPresenter: GamesListPresenterProtocol {

    // MARK: - Internal properties

    weak var view: GamesListViewControllerProtocol?

    // MARK: - GamesListPresenterProtocol

    func presentGames(result: Result<[GameDTO], Error>) {
        view?.displayGames(result: result)
    }
}
