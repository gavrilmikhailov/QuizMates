//
//  TopicEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

@MainActor
protocol TopicEditorInteractorProtocol {
    func loadTopicContent()
    func submitTopic(name: String)
    func deleteTopic()
}

@MainActor
final class TopicEditorInteractor: TopicEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: TopicEditorViewControllerProtocol?

    // MARK: - Private properties

    private let game: GameDTO
    private let mode: TopicEditorMode

    // MARK: - Initializer

    init(game: GameDTO, mode: TopicEditorMode) {
        self.game = game
        self.mode = mode
    }

    // MARK: - TopicEditorInteractorProtocol

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
            let newDraft = TopicDraft(name: name, createdAt: draft.createdAt)
            view?.displaySubmitNewTopic(topic: newDraft, game: game)
        case .editExistingTopic(let dto):
            let newDTO = TopicDTO(
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
