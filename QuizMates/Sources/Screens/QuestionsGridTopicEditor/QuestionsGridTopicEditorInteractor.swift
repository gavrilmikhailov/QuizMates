//
//  QuestionsGridTopicEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol QuestionsGridTopicEditorInteractorProtocol {
    func loadTopicContent()
    func submitTopic(name: String)
    func deleteTopic()
}

@MainActor
final class QuestionsGridTopicEditorInteractor: QuestionsGridTopicEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridTopicEditorViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let game: QuestionsGridGameDTO
    private let mode: QuestionsGridTopicEditorMode

    // MARK: - Initializer

    init(databaseService: DatabaseService, game: QuestionsGridGameDTO, mode: QuestionsGridTopicEditorMode) {
        self.databaseService = databaseService
        self.game = game
        self.mode = mode
    }

    // MARK: - QuestionsGridTopicEditorInteractorProtocol

    func loadTopicContent() {
        switch mode {
        case .createNewTopic(let draft):
            view?.displayContent(name: draft.name)
        case .editExistingTopic(let dto):
            view?.displayContent(name: dto.name)
        }
    }

    func submitTopic(name: String) {
        switch mode {
        case .createNewTopic(let draft):
            let newDraft = QuestionsGridTopicDraft(name: name, createdAt: draft.createdAt)
            view?.displaySubmitNewTopic(topic: newDraft, game: game)
        case .editExistingTopic(let dto):
            let newDTO = QuestionsGridTopicDTO(
                id: dto.id,
                name: name,
                createdAt: dto.createdAt,
                questions: dto.questions
            )
            view?.displaySubmitUpdatedTopic(topic: newDTO)
        }
    }

    func deleteTopic() {
        switch mode {
        case .createNewTopic:
            break
        case .editExistingTopic(let dto):
            view?.displayDeleteTopic(topic: dto)
        }
    }
}
