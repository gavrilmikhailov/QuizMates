//
//  GameResultsInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import DatabaseModule

@MainActor
protocol GameResultsInteractorProtocol {
    func loadPlayers()
}

@MainActor
final class GameResultsInteractor: GameResultsInteractorProtocol {

    // MARK: - Internal properties

    weak var view: GameResultsViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseServiceProtocol
    private let players: [PlayerDTO]

    // MARK: - Initializer

    init(databaseService: DatabaseServiceProtocol, players: [PlayerDTO]) {
        self.databaseService = databaseService
        self.players = players
    }

    // MARK: - GameResultsInteractorProtocol

    func loadPlayers() {
        let scores: Set<Int> = Set(players.map(\.score))
        let sortedScores: [Int] = scores.sorted { $0 > $1 }

        var results: [GameResult] = []
        for (index, score) in sortedScores.enumerated() {
            let playersWithScore = players.filter { $0.score == score }
            let result = GameResult(
                place: index + 1,
                playerNames: playersWithScore.map(\.name).joined(separator: ", "),
                score: score
            )
            results.append(result)
        }

        view?.displayPlayers(results: results)
    }
}
