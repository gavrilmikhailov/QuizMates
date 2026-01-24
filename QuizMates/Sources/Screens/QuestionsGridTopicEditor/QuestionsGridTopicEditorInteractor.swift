//
//  QuestionsGridTopicEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridTopicEditorInteractorProtocol {
    func submitTopic(name: String)
}

@MainActor
final class QuestionsGridTopicEditorInteractor: QuestionsGridTopicEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridTopicEditorViewControllerProtocol?

    // MARK: - Private properties

    private let game: QuestionsGridGameModel
    private let topic: QuestionsGridTopicModel

    // MARK: - Initializer

    init(game: QuestionsGridGameModel, topic: QuestionsGridTopicModel?) {
        self.game = game
        if let topic {
            self.topic = topic
        } else {
            self.topic = QuestionsGridTopicModel(name: "", createdAt: .now, questions: [])
        }
    }

    // MARK: - QuestionsGridTopicEditorInteractorProtocol

    func submitTopic(name: String) {
        topic.name = name
        view?.displaySubmitTopic(topic: topic, game: game)
    }
}
