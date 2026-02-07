//
//  GameProcessInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import DatabaseModule

@MainActor
protocol GameProcessInteractorProtocol {
    func loadGameContent()
    func navigateToQuestion(topic: TopicDTO, question: QuestionDTO)
}

@MainActor
final class GameProcessInteractor: GameProcessInteractorProtocol {

    // MARK: - Internal properties

    weak var view: ViewControllerProtocol?

    // MARK: - Private properties

    private let game: GameDTO
    private let databaseSevice: DatabaseServiceProtocol

    // MARK: - Interactor

    init(databaseSevice: DatabaseServiceProtocol, game: GameDTO) {
        self.databaseSevice = databaseSevice
        self.game = game
    }

    // MARK: - GameProcessInteractorProtocol

    func loadGameContent() {
        Task {
            do {
                let game = try await databaseSevice.fetch(id: game.id) { model in
                    return GameDTO(from: model)
                }
                let topics = try await databaseSevice.fetch(ids: game.topics) { model in
                    return TopicDTO(from: model)
                }
                var content: [(TopicDTO, [QuestionDTO])] = []
                var prices: Set<Int> = []
                for topic in topics {
                    let topicQuestions = try await databaseSevice.fetch(ids: topic.questions) { model in
                        return QuestionDTO(from: model)
                    }
                    prices.formUnion(topicQuestions.map(\.price))
                    content.append((topic, topicQuestions))
                }
                let players = try await databaseSevice.fetch(ids: game.players) { model in
                    return PlayerDTO(from: model)
                }
                await MainActor.run {
                    view?.displayGameContent(
                        title: game.name,
                        topics: content,
                        prices: prices.sorted(),
                        players: players
                    )
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func navigateToQuestion(topic: TopicDTO, question: QuestionDTO) {
        Task {
            do {
                let players = try await databaseSevice.fetch(ids: game.players) { model in
                    return PlayerDTO(from: model)
                }
                await MainActor.run {
                    view?.displayNavigateToQuestion(topic: topic, question: question, players: players)
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }
}
