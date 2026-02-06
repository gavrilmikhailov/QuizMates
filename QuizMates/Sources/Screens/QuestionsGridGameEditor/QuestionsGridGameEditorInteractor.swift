//
//  QuestionsGridGameEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftData

@MainActor
protocol QuestionsGridGameEditorInteractorProtocol {
    func createNewGameIfNeeded()
    func loadGameContent()
    func updateGameName(name: String)
    func addNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO)
    func updateTopic(topic: QuestionsGridTopicDTO)
    func deleteTopic(topic: QuestionsGridTopicDTO)
    func addNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    )
    func updateQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft])
    func deleteQuestion(question: QuestionsGridQuestionDTO)

    func addNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO)
    func updatePlayer(player: QuestionsGridPlayerDTO)
    func deletePlayer(player: QuestionsGridPlayerDTO)

    func navigateToCreateNewTopic()
    func navigateToEditTopic(topic: QuestionsGridTopicDTO?)
    func navigateToCreateNewQuestion(topic: QuestionsGridTopicDTO)
    func navigateToEditQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO)
    func navigateToEditPlayer(player: QuestionsGridPlayerDTO?)

    func navigateToGameProcess()

    func resetGameProgress()
}

@MainActor
final class QuestionsGridGameEditorInteractor: QuestionsGridGameEditorInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGameEditorPresenterProtocol
    private let databaseSevice: DatabaseService
    private var game: QuestionsGridGameDTO?
    private let isNew: Bool

    // MARK: - Initializer

    init(
        presenter: QuestionsGridGameEditorPresenterProtocol,
        databaseSevice: DatabaseService,
        game: QuestionsGridGameDTO?
    ) {
        self.presenter = presenter
        self.databaseSevice = databaseSevice
        self.game = game
        self.isNew = game == nil
    }

    // MARK: - QuestionsGridGameEditorInteractorProtocol

    func createNewGameIfNeeded() {
        if isNew, game == nil {
            Task {
                do {
                    let draft = QuestionsGridGameDraft(name: generateDefaultGameName(), createdAt: .now)
                    game = try await databaseSevice.createGame(draft: draft)
                    await MainActor.run {
                        presenter.presentGameLoading()
                    }
                } catch {
                    await MainActor.run {
                        presenter.presentError(text: error.localizedDescription)
                    }
                }
            }
        } else {
            presenter.presentGameLoading()
        }
    }

    func loadGameContent() {
        guard let gameId = game?.id else {
            presenter.presentError(text: "Ошибка")
            return
        }
        Task {
            do {
                let game = try await databaseSevice.readGame(id: gameId)
                let topics = try await databaseSevice.readTopics(ids: game.topics)
                var content: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])] = []
                for topic in topics {
                    let topicQuestions = try await databaseSevice.readQuestions(ids: topic.questions)
                    content.append((topic, topicQuestions))
                }
                let players = try await databaseSevice.readPlayers(ids: game.players)
                let hasAnsweredQuestions = content.contains { tuple in
                    tuple.1.contains(where: { $0.isAnswered })
                }
                let hasPlayersWithScore = players.contains(where: { $0.score != 0 })
                await MainActor.run {
                    presenter.presentGameContent(
                        game: game,
                        topics: content,
                        players: players,
                        hasProgress: hasAnsweredQuestions || hasPlayersWithScore
                    )
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func updateGameName(name: String) {
        guard let game else {
            presenter.presentError(text: "Ошибка")
            return
        }
        let newGame = QuestionsGridGameDTO(
            id: game.id,
            name: name,
            createdAt: game.createdAt,
            topics: game.topics,
            players: game.players
        )
        Task {
            do {
                try await databaseSevice.updateGame(dto: newGame)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func addNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) {
        Task {
            do {
                let _ = try await databaseSevice.createTopic(draft: topic, game: game)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func updateTopic(topic: QuestionsGridTopicDTO) {
        Task {
            do {
                try await databaseSevice.updateTopic(dto: topic)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func deleteTopic(topic: QuestionsGridTopicDTO) {
        Task {
            do {
                try await databaseSevice.deleteTopic(dto: topic)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func addNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    ) {
        Task {
            do {
                let _ = try await databaseSevice.createQuestion(draft: question, medias: medias, topic: topic)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func updateQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft]) {
        Task {
            do {
                try await databaseSevice.updateQuestion(dto: question, medias: medias)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func deleteQuestion(question: QuestionsGridQuestionDTO) {
        Task {
            do {
                try await databaseSevice.deleteQuestion(dto: question)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func addNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO) {
        Task {
            do {
                let _ = try await databaseSevice.createPlayer(draft: player, game: game)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func updatePlayer(player: QuestionsGridPlayerDTO) {
        Task {
            do {
                try await databaseSevice.updatePlayer(dto: player)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func deletePlayer(player: QuestionsGridPlayerDTO) {
        Task {
            do {
                try await databaseSevice.deletePlayer(dto: player)
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func navigateToCreateNewTopic() {
        guard let game else {
            return
        }
        presenter.presentNavigateToEditTopic(topic: nil, game: game)
    }

    func navigateToEditTopic(topic: QuestionsGridTopicDTO?) {
        guard let game else {
            return
        }
        presenter.presentNavigateToEditTopic(topic: topic, game: game)
    }

    func navigateToCreateNewQuestion(topic: QuestionsGridTopicDTO) {
        presenter.presentNavigateToEditQuestion(question: nil, topic: topic)
    }

    func navigateToEditQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO) {
        presenter.presentNavigateToEditQuestion(question: question, topic: topic)
    }

    func navigateToEditPlayer(player: QuestionsGridPlayerDTO?) {
        guard let game else {
            return
        }
        presenter.presentNavigateToEditPlayer(player: player, game: game)
    }

    func navigateToGameProcess() {
        guard let game else {
            return
        }
        presenter.presentNavigateToGameProcess(game: game)
    }

    func resetGameProgress() {
        guard let gameId = game?.id else {
            presenter.presentError(text: "Ошибка")
            return
        }
        Task {
            do {
                let game = try await databaseSevice.readGame(id: gameId)
                for topic in try await databaseSevice.readTopics(ids: game.topics) {
                    for question in try await databaseSevice.readQuestions(ids: topic.questions) {
                        try await databaseSevice.updateQuestion(dto: question, isAnswered: false)
                    }
                }
                for player in try await databaseSevice.readPlayers(ids: game.players) {
                    try await databaseSevice.updatePlayer(dto: player, score: 0)
                }
                await MainActor.run {
                    presenter.presentGameLoading()
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Private methods

    private func generateDefaultGameName() -> String {
        return "Игра"
        /*
        let numberOfGames = try? context.fetchCount(FetchDescriptor<QuestionsGridGameModel>())
        let newGameNumber = if let numberOfGames, numberOfGames > 0 {
            numberOfGames + 1
        } else {
            1
        }
        return "Игра №\(newGameNumber)"
        */
    }
}
