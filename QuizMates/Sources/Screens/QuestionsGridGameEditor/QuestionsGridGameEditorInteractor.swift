//
//  QuestionsGridGameEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftData

@MainActor
protocol QuestionsGridGameEditorInteractorProtocol {
    var game: QuestionsGridGameModel { get }

    func createNewGameIfNeeded()
    func loadGameName()
    func loadGameTopics()
    func updateGameName(name: String)
    func addNewTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel)
    func updateTopic(topic: QuestionsGridTopicModel)
    func deleteTopic(topic: QuestionsGridTopicModel)
    func addNewQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel)
    func updateQuestion(question: QuestionsGridQuestionModel)
    func deleteQuestion(question: QuestionsGridQuestionModel)
}

@MainActor
final class QuestionsGridGameEditorInteractor: QuestionsGridGameEditorInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGameEditorPresenterProtocol
    private let context: ModelContext
    var game: QuestionsGridGameModel
    private let isNew: Bool

    // MARK: - Initializer

    init(presenter: QuestionsGridGameEditorPresenterProtocol, context: ModelContext, game: QuestionsGridGameModel?) {
        self.presenter = presenter
        self.context = context
        if let game {
            self.game = game
        } else {
            self.game = QuestionsGridGameModel(name: "", topics: [], createdAt: .now)
        }
        self.isNew = game == nil
    }

    // MARK: - QuestionsGridGameEditorInteractorProtocol

    func createNewGameIfNeeded() {
        guard isNew else {
            return
        }
        game.name = generateDefaultGameName()
        context.insert(game)
        try? context.save()
    }

    func loadGameName() {
        presenter.presentGameName(name: game.name)
    }

    func loadGameTopics() {
        presenter.presentGameTopics(topics: game.topics)
    }

    func updateGameName(name: String) {
        game.name = name
        try? context.save()
    }

    func addNewTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel) {
        game.topics.append(topic)
        try? context.save()
    }

    func updateTopic(topic: QuestionsGridTopicModel) {
        try? context.save()
    }

    func deleteTopic(topic: QuestionsGridTopicModel) {
        context.delete(topic)
        try? context.save()
    }

    func addNewQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel) {
        topic.questions.append(question)
        try? context.save()
    }

    func updateQuestion(question: QuestionsGridQuestionModel) {
        try? context.save()
    }

    func deleteQuestion(question: QuestionsGridQuestionModel) {
        context.delete(question)
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
