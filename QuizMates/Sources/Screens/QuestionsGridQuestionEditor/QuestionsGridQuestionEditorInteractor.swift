//
//  QuestionsGridQuestionEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridQuestionEditorInteractorProtocol {
    func submitQuestion(text: String, answer: String, price: Int)
    func deleteQuestion()
}

@MainActor
final class QuestionsGridQuestionEditorInteractor: QuestionsGridQuestionEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridQuestionEditorViewControllerProtocol?

    // MARK: - Private properties

    private let topic: QuestionsGridTopicModel
    private let question: QuestionsGridQuestionModel

    // MARK: - Initializer

    init(topic: QuestionsGridTopicModel, question: QuestionsGridQuestionModel?) {
        self.topic = topic
        if let question {
            self.question = question
        } else {
            self.question = QuestionsGridQuestionModel(
                text: "",
                answer: "",
                price: 50,
                isAnswered: false
            )
        }
    }

    // MARK: - QuestionsGridQuestionEditorInteractorProtocol

    func submitQuestion(text: String, answer: String, price: Int) {
        question.text = text
        question.answer = answer
        question.price = price
        
        view?.displaySubmitQuestion(question: question, topic: topic)
    }

    func deleteQuestion() {
        view?.displayDeleteQuestion(question: question)
    }
}
