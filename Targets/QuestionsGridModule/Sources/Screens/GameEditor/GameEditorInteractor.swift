//
//  GameEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import DatabaseModule
import SwiftData

@MainActor
protocol GameEditorInteractorProtocol {
    func createNewGameIfNeeded()
    func loadGameContent()
    func updateGameName(name: String)
    func addNewTopic(topic: TopicDraft, game: GameDTO)
    func updateTopic(topic: TopicDTO)
    func deleteTopic(topic: TopicDTO)
    func addNewQuestion(
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    )
    func updateQuestion(question: QuestionDTO, medias: [MediaDraft])
    func deleteQuestion(question: QuestionDTO)

    func addNewPlayer(player: PlayerDraft, game: GameDTO)
    func updatePlayer(player: PlayerDTO)
    func deletePlayer(player: PlayerDTO)

    func navigateToCreateNewTopic()
    func navigateToEditTopic(topic: TopicDTO?)
    func navigateToCreateNewQuestion(topic: TopicDTO)
    func navigateToEditQuestion(question: QuestionDTO, topic: TopicDTO)
    func navigateToEditPlayer(player: PlayerDTO?)

    func navigateToGameProcess()
    func navigateToGameResults()

    func resetGameProgress()
}

@MainActor
final class GameEditorInteractor: GameEditorInteractorProtocol {

    // MARK: - Private properties

    private let presenter: GameEditorPresenterProtocol
    private let databaseSevice: DatabaseServiceProtocol
    private var game: GameDTO?
    private let isNew: Bool

    // MARK: - Initializer

    init(
        presenter: GameEditorPresenterProtocol,
        databaseSevice: DatabaseServiceProtocol,
        game: GameDTO?
    ) {
        self.presenter = presenter
        self.databaseSevice = databaseSevice
        self.game = game
        self.isNew = game == nil
    }

    // MARK: - GameEditorInteractorProtocol

    func createNewGameIfNeeded() {
        if isNew, game == nil {
            Task {
                do {
                    let draft = GameDraft(name: generateDefaultGameName(), createdAt: .now)
                    let newGameId = try await databaseSevice.create(from: draft) { draft in
                        return QuestionsGridGameModel(draft: draft)
                    }
                    game = try await databaseSevice.fetch(id: newGameId) { model in
                        return GameDTO(from: model)
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
        } else {
            presenter.presentGameLoading()
        }
    }

    func loadGameContent() {
        guard let gameId = game?.id else {
            presenter.presentError(text: Strings.errorSubtitle)
            return
        }
        Task {
            do {
                let game = try await databaseSevice.fetch(id: gameId) { model in
                    return GameDTO(from: model)
                }
                let topics = try await databaseSevice.fetch(ids: game.topics) { model in
                    return TopicDTO(from: model)
                }
                var content: [(TopicDTO, [QuestionDTO])] = []
                for topic in topics {
                    let topicQuestions = try await databaseSevice.fetch(ids: topic.questions) { model in
                        return QuestionDTO(from: model)
                    }
                    content.append((topic, topicQuestions))
                }
                let players = try await databaseSevice.fetch(ids: game.players) { model in
                    return PlayerDTO(from: model)
                }
                var questionsCount: Int = 0
                var answeredQuestionsCount: Int = 0
                for (_, questions) in content {
                    for question in questions {
                        questionsCount += 1
                        if question.isAnswered {
                            answeredQuestionsCount += 1
                        }
                    }
                }
                let hasPlayersWithScore = players.contains(where: { $0.score != 0 })
                let progressState: GameEditorProgressState
                if questionsCount == 0 || players.count == 0 {
                    progressState = .unableToStart
                } else if answeredQuestionsCount > 0, answeredQuestionsCount == questionsCount {
                    progressState = .finished
                } else if answeredQuestionsCount > 0, answeredQuestionsCount < questionsCount {
                    progressState = .inProgress
                } else if hasPlayersWithScore {
                    progressState = .inProgress
                } else {
                    progressState = .readyToStart
                }

                await MainActor.run {
                    presenter.presentGameContent(
                        game: game,
                        topics: content,
                        players: players,
                        progressState: progressState
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
            presenter.presentError(text: Strings.errorSubtitle)
            return
        }
        let newGame = GameDTO(
            id: game.id,
            name: name,
            createdAt: game.createdAt,
            topics: game.topics,
            players: game.players
        )
        Task {
            do {
                try await databaseSevice.update(id: game.id, with: newGame) { (model: QuestionsGridGameModel, dto: GameDTO) in
                    model.name = dto.name
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

    func addNewTopic(topic: TopicDraft, game: GameDTO) {
        Task {
            do {
                try await databaseSevice.update(id: game.id, with: game) { (game: QuestionsGridGameModel, dto: GameDTO) in
                    game.topics?.append(QuestionsGridTopicModel(draft: topic))
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

    func updateTopic(topic: TopicDTO) {
        Task {
            do {
                try await databaseSevice.update(id: topic.id, with: topic) { (model: QuestionsGridTopicModel, dto: TopicDTO) in
                    model.name = dto.name
                    model.createdAt = dto.createdAt
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

    func deleteTopic(topic: TopicDTO) {
        Task {
            do {
                try await databaseSevice.delete(modelType: QuestionsGridTopicModel.self, id: topic.id)
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
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    ) {
        Task {
            do {
                try await databaseSevice.update(id: topic.id, with: topic) { (model: QuestionsGridTopicModel, dto: TopicDTO) in
                    let question = QuestionsGridQuestionModel(draft: question)
                    question.medias = medias.map { draft in
                        return QuestionsGridMediaModel(draft: draft)
                    }
                    model.questions?.append(question)
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

    func updateQuestion(question: QuestionDTO, medias: [MediaDraft]) {
        Task {
            do {
                try await databaseSevice.update(id: question.id, with: question) { (model: QuestionsGridQuestionModel, dto) in
                    model.text = dto.text
                    model.answer = dto.answer
                    model.price = dto.price
                    model.isAnswered = dto.isAnswered

                    let newMedias = medias.map { media in
                        QuestionsGridMediaModel(draft: media)
                    }
                    model.medias?.append(contentsOf: newMedias)
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

    func deleteQuestion(question: QuestionDTO) {
        Task {
            do {
                try await databaseSevice.delete(modelType: QuestionsGridQuestionModel.self, id: question.id)
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

    func addNewPlayer(player: PlayerDraft, game: GameDTO) {
        Task {
            do {
                try await databaseSevice.update(id: game.id, with: game) { (game: QuestionsGridGameModel, dto) in
                    game.players?.append(QuestionsGridPlayerModel(draft: player))
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

    func updatePlayer(player: PlayerDTO) {
        Task {
            do {
                try await databaseSevice.update(id: player.id, with: player) { (model: QuestionsGridPlayerModel, dto) in
                    model.emoji = dto.emoji
                    model.name = dto.name
                    model.score = dto.score
                    model.createdAt = dto.createdAt
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

    func deletePlayer(player: PlayerDTO) {
        Task {
            do {
                try await databaseSevice.delete(modelType: QuestionsGridPlayerModel.self, id: player.id)
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

    func navigateToEditTopic(topic: TopicDTO?) {
        guard let game else {
            return
        }
        presenter.presentNavigateToEditTopic(topic: topic, game: game)
    }

    func navigateToCreateNewQuestion(topic: TopicDTO) {
        presenter.presentNavigateToEditQuestion(question: nil, topic: topic)
    }

    func navigateToEditQuestion(question: QuestionDTO, topic: TopicDTO) {
        presenter.presentNavigateToEditQuestion(question: question, topic: topic)
    }

    func navigateToEditPlayer(player: PlayerDTO?) {
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

    func navigateToGameResults() {
        guard let gameId = game?.id else {
            return
        }
        Task {
            do {
                let game = try await databaseSevice.fetch(id: gameId) { model in
                    return GameDTO(from: model)
                }
                let players = try await databaseSevice.fetch(ids: game.players) { model in
                    return PlayerDTO(from: model)
                }
                await MainActor.run {
                    presenter.presentNavigateToGameResults(players: players)
                }
            } catch {
                await MainActor.run {
                    presenter.presentError(text: error.localizedDescription)
                }
            }
        }
    }

    func resetGameProgress() {
        guard let gameId = game?.id else {
            presenter.presentError(text: Strings.errorSubtitle)
            return
        }
        Task {
            do {
                let game = try await databaseSevice.fetch(id: gameId) { model in
                    return GameDTO(from: model)
                }
                let topics = try await databaseSevice.fetch(ids: game.topics) { model in
                    return TopicDTO(from: model)
                }
                for topic in topics {
                    let questions = try await databaseSevice.fetch(ids: topic.questions) { model in
                        return QuestionDTO(from: model)
                    }
                    for question in questions {
                        try await databaseSevice.update(id: question.id, with: question) { (model: QuestionsGridQuestionModel, dto) in
                            model.isAnswered = false
                        }
                    }
                }
                let players = try await databaseSevice.fetch(ids: game.players) { model in
                    return PlayerDTO(from: model)
                }
                for player in players {
                    try await databaseSevice.update(id: player.id, with: player) { (model: QuestionsGridPlayerModel, dto) in
                        model.score = 0
                    }
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
        return Strings.gameDefaultName
    }
}
