//
//  QuestionsGridPlayerEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

@MainActor
protocol QuestionsGridPlayerEditorInteractorProtocol {
    func loadPlayerContent()
    func submitPlayer(emoji: String, name: String)
    func deletePlayer()
}

@MainActor
final class QuestionsGridPlayerEditorInteractor: QuestionsGridPlayerEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridPlayerEditorViewControllerProtocol?

    // MARK: - Private properties

    private let game: QuestionsGridGameDTO
    private let mode: QuestionsGridPlayerEditorMode

    // MARK: - Initializer

    init(game: QuestionsGridGameDTO, mode: QuestionsGridPlayerEditorMode) {
        self.game = game
        self.mode = mode
    }

    // MARK: - QuestionsGridPlayerEditorInteractorProtocol

    func loadPlayerContent() {
    }

    func submitPlayer(emoji: String, name: String) {
        switch mode {
        case .createNewPlayer(let draft):
            let newDraft = QuestionsGridPlayerDraft(emoji: emoji, name: name, order: 0)
            view?.displaySumbitNewPlayer(player: newDraft, game: game)
        case .editExistingPlayer(let dto):
            let newDTO = QuestionsGridPlayerDTO(
                id: dto.id,
                emoji: emoji,
                name: name,
                order: dto.order,
                score: dto.score
            )
            view?.displaySumbitUpdatedPlayer(player: newDTO)
        }
    }

    func deletePlayer() {
        switch mode {
        case .createNewPlayer:
            break
        case .editExistingPlayer(let dto):
            view?.displayDeletePlayer(player: dto)
        }
    }
}
