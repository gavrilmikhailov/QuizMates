//
//  GamesListInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import DatabaseModule
import Foundation

@MainActor
protocol GamesListInteractorProtocol: AnyObject {
    func fetchGames()
    func deleteGame(dto: GameDTO)
}

@MainActor
final class GamesListInteractor: GamesListInteractorProtocol {

    // MARK: - Private properties

    private let presenter: GamesListPresenterProtocol
    private let databaseService: DatabaseServiceProtocol
    private var games: [GameDTO] = []

    // MARK: - Initializer

    init(
        presenter: GamesListPresenterProtocol,
        databaseService: DatabaseServiceProtocol
    ) {
        self.presenter = presenter
        self.databaseService = databaseService
    }

    // MARK: - GamesListInteractorProtocol

    func fetchGames() {
        Task {
            do {
                games = try await databaseService.fetch(modelType: GameModel.self) { model in
                    return GameDTO(from: model)
                }
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

    func deleteGame(dto: GameDTO) {
        Task {
            do {
                try await databaseService.delete(modelType: GameModel.self, id: dto.id)
                games = try await databaseService.fetch(modelType: GameModel.self) { model in
                    return GameDTO(from: model)
                }
                await MainActor.run {
                    presenter.presentGames(result: .success(games))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
