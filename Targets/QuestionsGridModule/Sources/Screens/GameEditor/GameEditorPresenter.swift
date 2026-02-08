//
//  GameEditorPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

@MainActor
protocol GameEditorPresenterProtocol {
    func presentGameLoading()
    func presentGameContent(
        game: GameDTO,
        topics: [(TopicDTO, [QuestionDTO])],
        players: [PlayerDTO],
        progressState: GameEditorProgressState
    )
    func presentNavigateToEditTopic(topic: TopicDTO?, game: GameDTO)
    func presentNavigateToEditQuestion(question: QuestionDTO?, topic: TopicDTO)
    func presentNavigateToEditPlayer(player: PlayerDTO?, game: GameDTO)
    func presentNavigateToGameProcess(game: GameDTO)
    func presentNavigateToGameResults(players: [PlayerDTO])
    func presentError(text: String)
}

@MainActor
final class GameEditorPresenter: GameEditorPresenterProtocol {

    // MARK: - Internal properties

    weak var view: GameEditorViewControllerProtocol?

    // MARK: - GameEditorPresenterProtocol

    func presentGameLoading() {
        view?.displayGameLoading()
    }

    func presentGameContent(
        game: GameDTO,
        topics: [(TopicDTO, [QuestionDTO])],
        players: [PlayerDTO],
        progressState: GameEditorProgressState
    ) {
        let sortedTopics = topics
            .sorted { lhs, rhs in
                return lhs.0.createdAt < rhs.0.createdAt
            }
            .map { topic, questions in
                return (topic, questions.sorted { $0.price < $1.price })
            }
        let sortedPlayers = players.sorted { $0.createdAt < $1.createdAt }
        view?.displayGameContent(
            game: game,
            topics: sortedTopics,
            players: sortedPlayers,
            progressState: progressState
        )
    }

    func presentNavigateToEditTopic(topic: TopicDTO?, game: GameDTO) {
        view?.displayNavigateToEditTopic(topic: topic, game: game)
    }

    func presentNavigateToEditQuestion(question: QuestionDTO?, topic: TopicDTO) {
        view?.displayNavigateToEditQuestion(question: question, topic: topic)
    }

    func presentNavigateToEditPlayer(player: PlayerDTO?, game: GameDTO) {
        view?.displayNavigateToEditPlayer(player: player, game: game)
    }

    func presentNavigateToGameProcess(game: GameDTO) {
        view?.displayNavigateToGameProcess(game: game)
    }

    func presentNavigateToGameResults(players: [PlayerDTO]) {
        view?.displayNavigateToGameResults(players: players)
    }

    func presentError(text: String) {
        view?.displayError(text: text)
    }
}
