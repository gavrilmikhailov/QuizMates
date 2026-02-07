//
//  QuestionsGridGameProcessQuestionInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

@MainActor
protocol QuestionsGridGameProcessQuestionInteractorProtocol {
    func loadQuestionContent()
    func assignScore(player: QuestionsGridPlayerDTO, isAddition: Bool)
    func markQuestionAsAnswered()
}

@MainActor
final class QuestionsGridGameProcessQuestionInteractor: QuestionsGridGameProcessQuestionInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameProcessQuestionViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let topic: QuestionsGridTopicDTO
    private let question: QuestionsGridQuestionDTO
    private var players: [QuestionsGridPlayerDTO]

    // MARK: - Initializer

    init(
        databaseService: DatabaseService,
        topic: QuestionsGridTopicDTO,
        question: QuestionsGridQuestionDTO,
        players: [QuestionsGridPlayerDTO]
    ) {
        self.databaseService = databaseService
        self.topic = topic
        self.question = question
        self.players = players
    }

    // MARK: - QuestionsGridGameProcessQuestionInteractorProtocol

    func loadQuestionContent() {
        Task {
            var configurations: [QuestionsGridMediaPreviewConfiguration] = []
            for media in try await databaseService.readMedias(ids: question.medias) {
                let configuration = QuestionsGridMediaPreviewConfiguration(
                    fileName: media.fileName,
                    fileExtension: media.fileExtension,
                    type: media.type,
                    data: media.data
                )
                configurations.append(configuration)
            }
            view?.displayQuestionContent(
                title: "\(topic.name) – \(question.price.description)",
                medias: configurations,
                text: question.text,
                answer: question.answer
            )
            view?.displayPlayers(players: players)
        }
    }

    func assignScore(player: QuestionsGridPlayerDTO, isAddition: Bool) {
        Task {
            do {
                let newScore = player.score + (isAddition ? question.price : -question.price)
                try await databaseService.updatePlayer(dto: player, score: newScore)
                players = try await databaseService.readPlayers(ids: players.map(\.id))
                await MainActor.run {
                    view?.displayPlayers(players: players)
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func markQuestionAsAnswered() {
        Task {
            do {
                try await databaseService.updateQuestion(dto: question, isAnswered: true)
                await MainActor.run {
                    view?.displayMarkQuestionAsAnswered()
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }
}
