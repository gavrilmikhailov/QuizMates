//
//  QuestionsGridGameProcessInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

@MainActor
protocol QuestionsGridGameProcessInteractorProtocol {
    func loadGameContent()
}

@MainActor
final class QuestionsGridGameProcessInteractor: QuestionsGridGameProcessInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameProcessViewControllerProtocol?

    // MARK: - Private properties

    private let game: QuestionsGridGameDTO

    // MARK: - Interactor

    init(game: QuestionsGridGameDTO) {
        self.game = game
    }

    // MARK: - QuestionsGridGameProcessInteractorProtocol

    func loadGameContent() {
        view?.displayGameContent(title: game.name)
    }
}
