//
//  QuestionsGridGameProcessQuestionInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

@MainActor
protocol QuestionsGridGameProcessQuestionInteractorProtocol {
}

@MainActor
final class QuestionsGridGameProcessQuestionInteractor: QuestionsGridGameProcessQuestionInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridGameProcessQuestionViewControllerProtocol?

    // MARK: - QuestionsGridGameProcessQuestionInteractorProtocol
}
