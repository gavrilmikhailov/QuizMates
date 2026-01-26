//
//  QuestionsGridQuestionEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridQuestionEditorInteractorProtocol {
    func createNewQuestionIfNeeded()
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
    private var question: QuestionsGridQuestionDTO?
    private let isNew: Bool

    // MARK: - Initializer

    init(databaseService: DatabaseService, topic: QuestionsGridTopicDTO, question: QuestionsGridQuestionDTO?) {
        self.databaseService = databaseService
        self.topic = topic
        self.question = question
        self.isNew = question == nil
    }

    // MARK: - QuestionsGridQuestionEditorInteractorProtocol

    func createNewQuestionIfNeeded() {
        if isNew {
            Task {
                do {
                    let draft = QuestionsGridQuestionDraft(
                        text: "",
                        answer: "",
                        price: 50,
                        isAnswered: false
                    )
                    question = try await databaseService.createQuestion(draft: draft, topic: topic)
                    await MainActor.run {
                        view?.displayQuestionLoading()
                    }
                } catch {
                    await MainActor.run {
                        view?.displayError(text: error.localizedDescription)
                    }
                }
            }
        } else {
            view?.displayQuestionLoading()
        }
    }

    func loadQuestionContent() {
        guard let questionId = question?.id else {
            view?.displayError(text: "Ошибка")
            return
        }
        Task {
            do {
                let question = try await databaseService.readQuestion(id: questionId)
                self.question = question
                await MainActor.run {
                    view?.displayQuestionLoading()
                    view?.displayQuestionContent(question: question)
                }
            } catch {
                await MainActor.run {
                    view?.displayError(text: error.localizedDescription)
                }
            }
        }
    }

    func submitQuestion(text: String, answer: String, price: Int) {
        guard let question else {
            return
        }
        let newQuestion = QuestionsGridQuestionDTO(
            id: question.id,
            medias: question.medias,
            text: text,
            answer: answer,
            price: price,
            isAnswered: question.isAnswered
        )
        view?.displaySubmitQuestion(question: newQuestion, topic: topic)
    }

    func deleteQuestion() {
        guard let question else {
            return
        }
        view?.displayDeleteQuestion(question: question)
    }
}
