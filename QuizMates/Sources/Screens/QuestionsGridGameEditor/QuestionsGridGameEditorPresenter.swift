//
//  QuestionsGridGameEditorPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

@MainActor
protocol QuestionsGridGameEditorPresenterProtocol {
    func presentGameLoading()
    func presentGameContent(
        game: QuestionsGridGameDTO,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        players: [QuestionsGridPlayerDTO]
    )
    func presentNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO)
    func presentNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO)
    func presentNavigateToEditPlayer(player: QuestionsGridPlayerDTO?, game: QuestionsGridGameDTO)
    func presentError(text: String)
}

@MainActor
final class QuestionsGridGameEditorPresenter: QuestionsGridGameEditorPresenterProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameEditorViewControllerProtocol?

    // MARK: - QuestionsGridGameEditorPresenterProtocol

    func presentGameLoading() {
        view?.displayGameLoading()
    }

    func presentGameContent(
        game: QuestionsGridGameDTO,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        players: [QuestionsGridPlayerDTO]
    ) {
        let sortedTopics = topics
            .sorted { lhs, rhs in
                return lhs.0.createdAt < rhs.0.createdAt
            }
            .map { topic, questions in
                return (topic, questions.sorted { $0.price < $1.price })
            }
        let sortedPlayers = players.sorted { $0.order < $1.order }
        view?.displayGameContent(game: game, topics: sortedTopics, players: sortedPlayers)
    }

    func presentNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO) {
        view?.displayNavigateToEditTopic(topic: topic, game: game)
    }

    func presentNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO) {
        view?.displayNavigateToEditQuestion(question: question, topic: topic)
    }

    func presentNavigateToEditPlayer(player: QuestionsGridPlayerDTO?, game: QuestionsGridGameDTO) {
        view?.displayNavigateToEditPlayer(player: player, game: game)
    }

    func presentError(text: String) {
        view?.displayError(text: text)
    }
}
