//
//  GameProcessInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import CoreGraphics
import CoreModule
import DatabaseModule
import UserDefaultsModule

@MainActor
protocol GameProcessInteractorProtocol {
    func loadGameContent()
    func loadSettings()
    func saveTopicFontSize(value: CGFloat)
    func saveQuestionFontSize(value: CGFloat)
    func saveCellSize(value: CGFloat)
    func saveCellColor(value: ColorPreset)
    func navigateToQuestion(topic: TopicDTO, question: QuestionDTO)
    func checkGameResults()
}

@MainActor
final class GameProcessInteractor: GameProcessInteractorProtocol {

    // MARK: - Internal properties

    weak var view: GameProcessViewControllerProtocol?

    // MARK: - Private properties

    private let game: GameDTO
    private let databaseSevice: DatabaseServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let settingsSaveDebouncers: [String: UIDebouncer] = [
        UserDefaultsKey.gameProcessTopicFontSize.rawValue: UIDebouncer(duration: .seconds(1)),
        UserDefaultsKey.gameProcessQuestionFontSize.rawValue: UIDebouncer(duration: .seconds(1)),
        UserDefaultsKey.gameProcessCellSize.rawValue: UIDebouncer(duration: .seconds(1)),
        UserDefaultsKey.gameProcessCellColor.rawValue: UIDebouncer(duration: .seconds(1))
    ]

    // MARK: - Interactor

    init(databaseSevice: DatabaseServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol, game: GameDTO) {
        self.databaseSevice = databaseSevice
        self.userDefaultsService = userDefaultsService
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

    func loadSettings() {
        Task {
            do {
                let topicFontSize = try await userDefaultsService.get(Double.self, for: .gameProcessTopicFontSize)
                let questionFontSize = try await userDefaultsService.get(Double.self, for: .gameProcessQuestionFontSize)
                let cellSize = try await userDefaultsService.get(Double.self, for: .gameProcessCellSize)
                let cellColor = try await userDefaultsService.get(String.self, for: .gameProcessCellColor)

                await MainActor.run {
                    view?.displaySettings(
                        topicFontSize: topicFontSize,
                        questionFontSize: questionFontSize,
                        cellSize: cellSize,
                        cellColor: cellColor
                    )
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func saveTopicFontSize(value: CGFloat) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessTopicFontSize.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(Double(value), for: .gameProcessTopicFontSize)
            }
        }
    }

    func saveQuestionFontSize(value: CGFloat) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessQuestionFontSize.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(Double(value), for: .gameProcessQuestionFontSize)
            }
        }
    }

    func saveCellSize(value: CGFloat) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessCellSize.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(Double(value), for: .gameProcessCellSize)
            }
        }
    }

    func saveCellColor(value: ColorPreset) {
        settingsSaveDebouncers[UserDefaultsKey.gameProcessCellColor.rawValue]?.submit { [userDefaultsService] in
            Task {
                try? await userDefaultsService.set(value.rawValue, for: .gameProcessCellColor)
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

    func checkGameResults() {
        Task {
            do {
                let game = try await databaseSevice.fetch(id: game.id) { model in
                    return GameDTO(from: model)
                }
                let topics = try await databaseSevice.fetch(ids: game.topics) { model in
                    return TopicDTO(from: model)
                }
                var questions: [QuestionDTO] = []
                for topic in topics {
                    let topicQuestions = try await databaseSevice.fetch(ids: topic.questions) { model in
                        return QuestionDTO(from: model)
                    }
                    questions.append(contentsOf: topicQuestions)
                }
                if questions.allSatisfy(\.isAnswered) {
                    let players = try await databaseSevice.fetch(ids: game.players) { model in
                        return PlayerDTO(from: model)
                    }
                    await MainActor.run {
                        view?.displayGameResults(players: players)
                    }
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }
}
