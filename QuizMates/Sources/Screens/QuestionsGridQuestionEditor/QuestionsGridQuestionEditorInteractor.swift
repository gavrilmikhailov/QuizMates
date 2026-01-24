//
//  QuestionsGridQuestionEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridQuestionEditorInteractorProtocol {
    func submitQuestion(text: String, answer: String, price: Int)
}

@MainActor
final class QuestionsGridQuestionEditorInteractor: QuestionsGridQuestionEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridQuestionEditorViewControllerProtocol?

    // MARK: - Private properties

    private lazy var question = QuestionsGridQuestionModel(
        text: "",
        answer: "",
        price: 50,
        isAnswered: false
    )

    // MARK: - QuestionsGridQuestionEditorInteractorProtocol

    func submitQuestion(text: String, answer: String, price: Int) {
        question.text = text
        question.answer = answer
        question.price = price
        
        view?.displaySubmitQuestion(question: question)
    }
}
