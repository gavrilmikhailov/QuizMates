//
//  QuestionsGridGameEditorPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

@MainActor
protocol QuestionsGridGameEditorPresenterProtocol {
    func presentGameName(name: String)
    func presentGameTopics(topics: [QuestionsGridTopicModel])
}

@MainActor
final class QuestionsGridGameEditorPresenter: QuestionsGridGameEditorPresenterProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameEditorViewControllerProtocol?

    // MARK: - QuestionsGridGameEditorPresenterProtocol

    func presentGameName(name: String) {
        view?.displayGameName(name: name)
    }

    func presentGameTopics(topics: [QuestionsGridTopicModel]) {
        view?.displayGameTopics(topics: topics)
    }
}
