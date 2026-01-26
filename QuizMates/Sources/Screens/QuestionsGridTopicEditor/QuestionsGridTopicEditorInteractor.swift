//
//  QuestionsGridTopicEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridTopicEditorInteractorProtocol {
    func createNewTopicIfNeeded()
    func loadTopicContent()
    func submitTopic(name: String)
    func deleteTopic()
}

@MainActor
final class QuestionsGridTopicEditorInteractor: QuestionsGridTopicEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridTopicEditorViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let game: QuestionsGridGameDTO
    private var topic: QuestionsGridTopicDTO?
    private let isNew: Bool

    // MARK: - Initializer

    init(databaseService: DatabaseService, game: QuestionsGridGameDTO, topic: QuestionsGridTopicDTO?) {
        self.databaseService = databaseService
        self.game = game
        self.topic = topic
        self.isNew = topic == nil
    }

    // MARK: - QuestionsGridTopicEditorInteractorProtocol

    func createNewTopicIfNeeded() {
        if isNew {
            Task {
                do {
                    let topic = try await databaseService.createTopic(
                        draft: QuestionsGridTopicDraft(name: "", createdAt: .now),
                        game: game
                    )
                    self.topic = topic
                    await MainActor.run {
                        view?.displayContentLoading()
                    }
                } catch {
                    await MainActor.run {
                        view?.displayError(text: error.localizedDescription)
                    }
                }
            }
        } else {
            view?.displayContentLoading()
        }
    }

    func loadTopicContent() {
        guard let topicId = topic?.id else {
            view?.displayError(text: "Ошибка")
            return
        }
        Task {
            do {
                let topic = try await databaseService.readTopic(id: topicId)
                self.topic = topic
                await MainActor.run {
                    view?.displayContent(topic: topic)
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func submitTopic(name: String) {
        guard let topic else {
            return
        }
        let newTopic = QuestionsGridTopicDTO(
            id: topic.id,
            name: name,
            createdAt: topic.createdAt,
            questions: topic.questions
        )
        view?.displaySubmitTopic(topic: newTopic, game: game)
    }

    func deleteTopic() {
        guard let topic else {
            return
        }
        view?.displayDeleteTopic(topic: topic)
    }
}
