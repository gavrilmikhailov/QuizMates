//
//  QuestionsGridTopicEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridTopicEditorInteractorProtocol {
    func updateTopicName(name: String)
}

@MainActor
final class QuestionsGridTopicEditorInteractor: QuestionsGridTopicEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridTopicEditorViewControllerProtocol?

    // MARK: - Private properties

    private let topic = QuestionsGridTopicModel(name: "", questions: [])

    // MARK: - QuestionsGridTopicEditorInteractorProtocol

    func updateTopicName(name: String) {
        topic.name = name
        view?.displaySubmitNewTopicName(topic: topic)
    }
}
