//
//  QuestionsGridGamesListInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation
import SwiftData

@MainActor
protocol QuestionsGridGamesListInteractorProtocol: AnyObject {
    func fetchGames()
}

@MainActor
final class QuestionsGridGamesListInteractor: QuestionsGridGamesListInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGamesListPresenterProtocol
    private let context: ModelContext

    private var games: [QuestionsGridGameModel] = []

    // MARK: - Initializer

    init(presenter: QuestionsGridGamesListPresenterProtocol, context: ModelContext) {
        self.presenter = presenter
        self.context = context
    }

    // MARK: - QuestionsGridGamesListInteractorProtocol

    func fetchGames() {
        let descriptor = FetchDescriptor<QuestionsGridGameModel>(sortBy: [SortDescriptor(\.createdAt)])
        do {
            games = try context.fetch(descriptor)
            presenter.presentGames(result: .success(games))
        } catch {
            presenter.presentGames(result: .failure(error))
        }
    }
}
