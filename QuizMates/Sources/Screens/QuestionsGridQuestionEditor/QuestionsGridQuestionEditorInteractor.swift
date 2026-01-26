//
//  QuestionsGridQuestionEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridQuestionEditorInteractorProtocol {
    func loadQuestionContent()
    func submitQuestion(text: String, answer: String, price: Int)
    func deleteQuestion()
}

@MainActor
final class QuestionsGridQuestionEditorInteractor: QuestionsGridQuestionEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridQuestionEditorViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let topic: QuestionsGridTopicDTO
    private let mode: QuestionsGridQuestionEditorMode

    // MARK: - Initializer

    init(databaseService: DatabaseService, topic: QuestionsGridTopicDTO, mode: QuestionsGridQuestionEditorMode) {
        self.databaseService = databaseService
        self.topic = topic
        self.mode = mode
    }

    // MARK: - QuestionsGridQuestionEditorInteractorProtocol

    func loadQuestionContent() {
        switch mode {
        case .createNewQuestion(let draft):
            view?.displayQuestionContent(text: draft.text, answer: draft.answer, price: draft.price)
        case .editExistingQuestion(let dto):
            view?.displayQuestionContent(text: dto.text, answer: dto.answer, price: dto.price)
        }
    }

    func submitQuestion(text: String, answer: String, price: Int) {
        switch mode {
        case .createNewQuestion(let draft):
            let newDraft = QuestionsGridQuestionDraft(
                text: text,
                answer: answer,
                price: price,
                isAnswered: draft.isAnswered
            )
            view?.displaySubmitNewQuestion(question: newDraft, topic: topic)
        case .editExistingQuestion(let dto):
            let newDTO = QuestionsGridQuestionDTO(
                id: dto.id,
                medias: dto.medias,
                text: text,
                answer: answer,
                price: price,
                isAnswered: dto.isAnswered
            )
            view?.displaySubmitUpdatedQuestion(question: newDTO)
        }
    }

    func deleteQuestion() {
        switch mode {
        case .createNewQuestion:
            break
        case .editExistingQuestion(let dto):
            view?.displayDeleteQuestion(question: dto)
        }
    }
}
