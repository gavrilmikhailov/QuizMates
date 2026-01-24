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
    func cleanUp()
    func fetchGames()
    func deleteGame(model: QuestionsGridGameModel)
}

@MainActor
final class QuestionsGridGamesListInteractor: QuestionsGridGamesListInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGamesListPresenterProtocol
    private let mediaStorageService: MediaStorageServiceProtocol
    private let context: ModelContext

    private var games: [QuestionsGridGameModel] = []

    // MARK: - Initializer

    init(
        presenter: QuestionsGridGamesListPresenterProtocol,
        mediaStorageService: MediaStorageServiceProtocol,
        context: ModelContext
    ) {
        self.presenter = presenter
        self.mediaStorageService = mediaStorageService
        self.context = context
    }

    // MARK: - QuestionsGridGamesListInteractorProtocol

    func cleanUp() {
        mediaStorageService.removeOrphanedItems(modelContext: context)
    }

    func fetchGames() {
        let descriptor = FetchDescriptor<QuestionsGridGameModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            games = try context.fetch(descriptor)
            presenter.presentGames(result: .success(games))
        } catch {
            presenter.presentGames(result: .failure(error))
        }
    }

    func deleteGame(model: QuestionsGridGameModel) {
        context.delete(model)
        try? context.save()
    }
}
