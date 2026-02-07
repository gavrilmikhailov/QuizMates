//
//  QuestionsGridGameProcessInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

@MainActor
protocol QuestionsGridGameProcessInteractorProtocol {
    func loadGameContent()
    func navigateToQuestion(topic: QuestionsGridTopicDTO, question: QuestionsGridQuestionDTO)
}

@MainActor
final class QuestionsGridGameProcessInteractor: QuestionsGridGameProcessInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameProcessViewControllerProtocol?

    // MARK: - Private properties

    private let game: QuestionsGridGameDTO
    private let databaseSevice: DatabaseService

    // MARK: - Interactor

    init(databaseSevice: DatabaseService, game: QuestionsGridGameDTO) {
        self.databaseSevice = databaseSevice
        self.game = game
    }

    // MARK: - QuestionsGridGameProcessInteractorProtocol

    func loadGameContent() {
        Task {
            do {
                let game = try await databaseSevice.readGame(id: game.id)
                let topics = try await databaseSevice.readTopics(ids: game.topics)
                var content: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])] = []
                var prices: Set<Int> = []
                for topic in topics {
                    let topicQuestions = try await databaseSevice.readQuestions(ids: topic.questions)
                    prices.formUnion(topicQuestions.map(\.price))
                    content.append((topic, topicQuestions))
                }
                let players = try await databaseSevice.readPlayers(ids: game.players)
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

    func navigateToQuestion(topic: QuestionsGridTopicDTO, question: QuestionsGridQuestionDTO) {
        Task {
            do {
                let players = try await databaseSevice.readPlayers(ids: game.players)
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
