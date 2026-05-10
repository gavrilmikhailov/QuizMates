//
//  GameProcessQuestionInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import CoreGraphics
import CoreModule
import DatabaseModule
import UserDefaultsModule

@MainActor
protocol GameProcessQuestionInteractorProtocol {
    func loadQuestionContent()
    func loadSettings()
    func saveQuestionFontSize(value: CGFloat)
    func savePlayerNameFontSize(value: CGFloat)
    func assignScore(player: PlayerDTO, isAddition: Bool)
    func markQuestionAsAnswered()
}

@MainActor
final class GameProcessQuestionInteractor: GameProcessQuestionInteractorProtocol {

    // MARK: - Internal properties

    weak var view: GameProcessQuestionViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let settingsSaveDebouncers: [String: UIDebouncer] = [
        UserDefaultsKey.gameProcessQuestionQuestionFontSize.rawValue: UIDebouncer(duration: .seconds(1)),
        UserDefaultsKey.gameProcessQuestionPlayerNameFontSize.rawValue: UIDebouncer(duration: .seconds(1)),
    ]
    private let topic: TopicDTO
    private let question: QuestionDTO
    private var players: [PlayerDTO]

    // MARK: - Initializer

    init(
        databaseService: DatabaseServiceProtocol,
        userDefaultsService: UserDefaultsServiceProtocol,
        topic: TopicDTO,
        question: QuestionDTO,
        players: [PlayerDTO]
    ) {
        self.databaseService = databaseService
        self.userDefaultsService = userDefaultsService
        self.topic = topic
        self.question = question
        self.players = players
    }

    // MARK: - GameProcessQuestionInteractorProtocol

    func loadQuestionContent() {
        Task {
            var configurations: [MediaPreviewConfiguration] = []
            let medias = try await databaseService.fetch(ids: question.medias) { model in
                return MediaDTO(from: model)
            }
            for media in medias {
                let configuration = MediaPreviewConfiguration(
                    fileName: media.fileName,
                    fileExtension: media.fileExtension,
                    type: media.type,
                    data: media.data
                )
                configurations.append(configuration)
            }
            view?.displayQuestionContent(
                price: question.price,
                title: "\(topic.name) – \(question.price.description)",
                medias: configurations,
                text: question.text,
                answer: question.answer
            )
            view?.displayPlayers(players: players)
        }
    }

    func loadSettings() {
        Task {
            do {
                let questionFontSize = try await userDefaultsService.get(Double.self, for: .gameProcessQuestionQuestionFontSize)
                let playerNameFontSize = try await userDefaultsService.get(Double.self, for: .gameProcessQuestionPlayerNameFontSize)

                await MainActor.run {
                    view?.displaySettings(
                        questionFontSize: questionFontSize,
                        playerNameFontSize: playerNameFontSize,
                    )
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func saveQuestionFontSize(value: CGFloat) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessQuestionQuestionFontSize.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(Double(value), for: .gameProcessQuestionQuestionFontSize)
            }
        }
    }

    func savePlayerNameFontSize(value: CGFloat) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessQuestionPlayerNameFontSize.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(Double(value), for: .gameProcessQuestionPlayerNameFontSize)
            }
        }
    }

    func assignScore(player: PlayerDTO, isAddition: Bool) {
        Task {
            do {
                let newScore = player.score + (isAddition ? question.price : -question.price)
                try await databaseService.update(id: player.id, with: player) { (model: QuestionsGridPlayerModel, dto) in
                    model.score = newScore
                }
                players = try await databaseService.fetch(ids: players.map(\.id)) { model in
                    return PlayerDTO(from: model)
                }
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
                try await databaseService.update(id: question.id, with: question) { (model: QuestionsGridQuestionModel, dto) in
                    model.isAnswered = true
                }
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
