//
//  QuestionsGridGamesListInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation

@MainActor
protocol QuestionsGridGamesListInteractorProtocol: AnyObject {
    func deleteOrphanedFiles()
    func fetchGames()
    func deleteGame(dto: QuestionsGridGameDTO)
}

@MainActor
final class QuestionsGridGamesListInteractor: QuestionsGridGamesListInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGamesListPresenterProtocol
    private let databaseService: DatabaseService
    private let mediaStorageService: MediaStorageService
    private var games: [QuestionsGridGameDTO] = []

    // MARK: - Initializer

    init(
        presenter: QuestionsGridGamesListPresenterProtocol,
        databaseService: DatabaseService,
        mediaStorageService: MediaStorageService
    ) {
        self.presenter = presenter
        self.databaseService = databaseService
        self.mediaStorageService = mediaStorageService
    }

    // MARK: - QuestionsGridGamesListInteractorProtocol

    func deleteOrphanedFiles() {
        Task {
            await mediaStorageService.removeOrphanedItems()
        }
    }

    func fetchGames() {
        Task {
            do {
                games = try await databaseService.readGames()
                await MainActor.run {
                    presenter.presentGames(result: .success(games))
                }
            } catch {
                await MainActor.run {
                    presenter.presentGames(result: .failure(error))
                }
            }
        }
    }

    func deleteGame(dto: QuestionsGridGameDTO) {
        Task {
            do {
                try await databaseService.deleteGame(id: dto.id)
                games = try await databaseService.readGames()
                await MainActor.run {
                    presenter.presentGames(result: .success(games))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
