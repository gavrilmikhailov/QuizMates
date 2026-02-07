//
//  GameEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol GameEditorViewControllerProtocol: AnyObject {
    func displayGameLoading()
    func displayGameContent(
        game: GameDTO,
        topics: [(TopicDTO, [QuestionDTO])],
        players: [PlayerDTO],
        hasProgress: Bool
    )
    func displayNavigateToEditTopic(topic: TopicDTO?, game: GameDTO)
    func displayNavigateToEditQuestion(question: QuestionDTO?, topic: TopicDTO)
    func displayNavigateToEditPlayer(player: PlayerDTO?, game: GameDTO)
    func displayNavigateToGameProcess(game: GameDTO)
    func displayError(text: String)
}

final class GameEditorViewController: UIHostingController<GameEditorView> {

    // MARK: - Internal properties

    var onEditTopic: ((TopicDTO?, GameDTO) -> Void)?
    var onEditQuestion: ((QuestionDTO?, TopicDTO) -> Void)?
    var onEditPlayer: ((PlayerDTO?, GameDTO) -> Void)?
    var onOpenGameProcess: ((GameDTO) -> Void)?

    // MARK: - Private properties

    private let interactor: GameEditorInteractorProtocol
    private let viewModel: GameEditorViewModel

    private let resetGameProgressAlertMessageLong = "Перед изменением данных игры необходимо сбросить прогресс текущей игры.\nВы уверены, что хотите сбросить прогресс текущей игры?"
    private let resetGameProgressAlertMessage = "Вы уверены, что хотите сбросить прогресс текущей игры?"

    // MARK: - Initializer

    init(
        interactor: GameEditorInteractorProtocol,
        viewModel: GameEditorViewModel,
        rootView: GameEditorView
    ) {
        self.interactor = interactor
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        interactor.createNewGameIfNeeded()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func resetGameProgressConfirmation(topic: TopicDTO) {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить эту тему?\nВсе вопросы из этой темы будут также удалены",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteTopic(topic: topic)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    private func presentResetGameProgressConfirmation(message: String) {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: message,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Сбросить", style: .destructive) { [weak self] _ in
            self?.interactor.resetGameProgress()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - GameEditorViewControllerProtocol

extension GameEditorViewController: GameEditorViewControllerProtocol {

    func displayGameLoading() {
        interactor.loadGameContent()
    }

    func displayGameContent(
        game: GameDTO,
        topics: [(TopicDTO, [QuestionDTO])],
        players: [PlayerDTO],
        hasProgress: Bool
    ) {
        viewModel.name = game.name
        viewModel.topics = topics
        viewModel.players = players
        viewModel.hasProgress = hasProgress
    }

    func displayNavigateToEditTopic(topic: TopicDTO?, game: GameDTO) {
        onEditTopic?(topic, game)
    }

    func displayNavigateToEditQuestion(question: QuestionDTO?, topic: TopicDTO) {
        onEditQuestion?(question, topic)
    }

    func displayNavigateToEditPlayer(player: PlayerDTO?, game: GameDTO) {
        onEditPlayer?(player, game)
    }

    func displayNavigateToGameProcess(game: GameDTO) {
        onOpenGameProcess?(game)
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - GameEditorViewDelegate

extension GameEditorViewController: GameEditorViewDelegate {

    func didSumbitNewGameName(name: String) {
        interactor.updateGameName(name: name)
    }

    func didTapCreateNewTopic() {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditTopic(topic: nil)
        }
    }

    func didTapEditTopic(topic: TopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditTopic(topic: topic)
        }
    }

    func didTapDeleteTopic(topic: TopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            let alert = UIAlertController(
                title: "Подтверждение",
                message: "Вы уверены, что хотите удалить эту тему?\nВсе вопросы из этой темы будут также удалены",
                preferredStyle: .alert
            )

            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                self?.interactor.deleteTopic(topic: topic)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

            alert.addAction(cancelAction)
            alert.addAction(deleteAction)

            present(alert, animated: true, completion: nil)
        }
    }

    func didTapCreateNewQuestion(topic: TopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToCreateNewQuestion(topic: topic)
        }
    }

    func didTapEditQuestion(question: QuestionDTO, topic: TopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditQuestion(question: question, topic: topic)
        }
    }

    func didTapDeleteQuestion(question: QuestionDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            let alert = UIAlertController(
                title: "Подтверждение",
                message: "Вы уверены, что хотите удалить этот вопрос?",
                preferredStyle: .alert
            )

            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                self?.interactor.deleteQuestion(question: question)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

            alert.addAction(cancelAction)
            alert.addAction(deleteAction)

            present(alert, animated: true, completion: nil)
        }
    }

    func didTapCreateNewPlayer() {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditPlayer(player: nil)
        }
    }

    func didTapEditPlayer(player: PlayerDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditPlayer(player: player)
        }
    }

    func didTapResetGame() {
        presentResetGameProgressConfirmation(message: resetGameProgressAlertMessage)
    }

    func didTapStartGame() {
        interactor.navigateToGameProcess()
    }
}

// MARK: - TopicEditorDelegate

extension GameEditorViewController: TopicEditorDelegate {

    func didSubmitNewTopic(topic: TopicDraft, game: GameDTO) {
        interactor.addNewTopic(topic: topic, game: game)
    }

    func didSubmitUpdatedTopic(topic: TopicDTO) {
        interactor.updateTopic(topic: topic)
    }

    func didDeleteTopic(topic: TopicDTO) {
        interactor.deleteTopic(topic: topic)
    }
}

// MARK: - QuestionEditorDelegate

extension GameEditorViewController: QuestionEditorDelegate {

    func didSubmitNewQuestion(
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    ) {
        interactor.addNewQuestion(question: question, medias: medias, topic: topic)
    }

    func didSubmitUpdatedQuestion(question: QuestionDTO, medias: [MediaDraft]) {
        interactor.updateQuestion(question: question, medias: medias)
    }

    func didDeleteQuestion(question: QuestionDTO) {
        interactor.deleteQuestion(question: question)
    }
}

// MARK: - PlayerEditorDelegate

extension GameEditorViewController: PlayerEditorDelegate {

    func didSubmitNewPlayer(player: PlayerDraft, game: GameDTO) {
        interactor.addNewPlayer(player: player, game: game)
    }

    func didSubmitUpdatedPlayer(player: PlayerDTO) {
        interactor.updatePlayer(player: player)
    }

    func didDeletePlayer(player: PlayerDTO) {
        interactor.deletePlayer(player: player)
    }
}
