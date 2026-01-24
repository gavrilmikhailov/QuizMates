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
    func loadGameName()
    func loadGameTopics()
    func updateGameName(name: String)
    func addNewTopic(topic: QuestionsGridTopicModel)
    func addNewQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel)
    func updateQuestion(question: QuestionsGridQuestionModel)
}

@MainActor
final class QuestionsGridGameEditorInteractor: QuestionsGridGameEditorInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGameEditorPresenterProtocol
    private let context: ModelContext
    private var model: QuestionsGridGameModel?

    // MARK: - Initializer

    init(presenter: QuestionsGridGameEditorPresenterProtocol, context: ModelContext, model: QuestionsGridGameModel?) {
        self.presenter = presenter
        self.context = context
        self.model = model
    }

    // MARK: - QuestionsGridGameEditorInteractorProtocol

    func createNewGameIfNeeded() {
        guard model == nil else {
            return
        }
        let defaultName = generateDefaultGameName()
        let newGame = QuestionsGridGameModel(name: defaultName, topics: [], createdAt: .now)
        model = newGame
        context.insert(newGame)
        try? context.save()
    }

    func loadGameName() {
        guard let model else {
            return
        }
        presenter.presentGameName(name: model.name)
    }

    func loadGameTopics() {
        let topics = model?.topics ?? []
        presenter.presentGameTopics(topics: topics)
    }

    func updateGameName(name: String) {
        model?.name = name
        try? context.save()
    }

    func addNewTopic(topic: QuestionsGridTopicModel) {
        model?.topics.append(topic)
        try? context.save()
    }

    func addNewQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel) {
        topic.questions.append(question)
        try? context.save()
    }

    func updateQuestion(question: QuestionsGridQuestionModel) {
        try? context.save()
    }

    // MARK: - Private methods

    private func generateDefaultGameName() -> String {
        let numberOfGames = try? context.fetchCount(FetchDescriptor<QuestionsGridGameModel>())
        let newGameNumber = if let numberOfGames, numberOfGames > 0 {
            numberOfGames + 1
        } else {
            1
        }
        return "Игра №\(newGameNumber)"
    }
}
