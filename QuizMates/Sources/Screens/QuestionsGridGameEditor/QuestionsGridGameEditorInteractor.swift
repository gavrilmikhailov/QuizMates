//
//  QuestionsGridGameEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftData

protocol QuestionsGridGameEditorInteractorProtocol {
    func createNewGame()
}

final class QuestionsGridGameEditorInteractor: QuestionsGridGameEditorInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridGameEditorPresenterProtocol
    private let context: ModelContext

    // MARK: - Initializer

    init(presenter: QuestionsGridGameEditorPresenterProtocol, context: ModelContext) {
        self.presenter = presenter
        self.context = context
    }

    // MARK: - QuestionsGridGameEditorInteractorProtocol

    func createNewGame() {
        let newGame = QuestionsGridGameModel(name: "", topics: [], createdAt: .now)
        context.insert(newGame)
        try? context.save()
    }
}
