//
//  QuestionsGridGameEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameEditorViewControllerProtocol: AnyObject {
    func displayGameLoading()
    func displayGameContent(
        game: QuestionsGridGameDTO,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        players: [QuestionsGridPlayerDTO],
        hasProgress: Bool
    )
    func displayNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO)
    func displayNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO)
    func displayNavigateToEditPlayer(player: QuestionsGridPlayerDTO?, game: QuestionsGridGameDTO)
    func displayNavigateToGameProcess(game: QuestionsGridGameDTO)
    func displayError(text: String)
}

final class QuestionsGridGameEditorViewController: UIHostingController<QuestionsGridGameEditorView> {

    // MARK: - Internal properties

    var onEditTopic: ((QuestionsGridTopicDTO?, QuestionsGridGameDTO) -> Void)?
    var onEditQuestion: ((QuestionsGridQuestionDTO?, QuestionsGridTopicDTO) -> Void)?
    var onEditPlayer: ((QuestionsGridPlayerDTO?, QuestionsGridGameDTO) -> Void)?
    var onOpenGameProcess: ((QuestionsGridGameDTO) -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGameEditorInteractorProtocol
    private let viewModel: QuestionsGridGameEditorViewModel

    private let resetGameProgressAlertMessageLong = "Перед изменением данных игры необходимо сбросить прогресс текущей игры.\nВы уверены, что хотите сбросить прогресс текущей игры?"
    private let resetGameProgressAlertMessage = "Вы уверены, что хотите сбросить прогресс текущей игры?"

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameEditorInteractorProtocol,
        viewModel: QuestionsGridGameEditorViewModel,
        rootView: QuestionsGridGameEditorView
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

    private func resetGameProgressConfirmation(topic: QuestionsGridTopicDTO) {
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

// MARK: - QuestionsGridGameEditorViewControllerProtocol

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewControllerProtocol {

    func displayGameLoading() {
        interactor.loadGameContent()
    }

    func displayGameContent(
        game: QuestionsGridGameDTO,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        players: [QuestionsGridPlayerDTO],
        hasProgress: Bool
    ) {
        viewModel.name = game.name
        viewModel.topics = topics
        viewModel.players = players
        viewModel.hasProgress = hasProgress
    }

    func displayNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO) {
        onEditTopic?(topic, game)
    }

    func displayNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO) {
        onEditQuestion?(question, topic)
    }

    func displayNavigateToEditPlayer(player: QuestionsGridPlayerDTO?, game: QuestionsGridGameDTO) {
        onEditPlayer?(player, game)
    }

    func displayNavigateToGameProcess(game: QuestionsGridGameDTO) {
        onOpenGameProcess?(game)
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridGameEditorViewDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewDelegate {

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

    func didTapEditTopic(topic: QuestionsGridTopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditTopic(topic: topic)
        }
    }

    func didTapDeleteTopic(topic: QuestionsGridTopicDTO) {
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

    func didTapCreateNewQuestion(topic: QuestionsGridTopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToCreateNewQuestion(topic: topic)
        }
    }

    func didTapEditQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO) {
        if viewModel.hasProgress {
            presentResetGameProgressConfirmation(message: resetGameProgressAlertMessageLong)
        } else {
            interactor.navigateToEditQuestion(question: question, topic: topic)
        }
    }

    func didTapDeleteQuestion(question: QuestionsGridQuestionDTO) {
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

    func didTapEditPlayer(player: QuestionsGridPlayerDTO) {
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

// MARK: - QuestionsGridTopicEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridTopicEditorDelegate {

    func didSubmitNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) {
        interactor.addNewTopic(topic: topic, game: game)
    }

    func didSubmitUpdatedTopic(topic: QuestionsGridTopicDTO) {
        interactor.updateTopic(topic: topic)
    }

    func didDeleteTopic(topic: QuestionsGridTopicDTO) {
        interactor.deleteTopic(topic: topic)
    }
}

// MARK: - QuestionsGridQuestionEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridQuestionEditorDelegate {

    func didSubmitNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    ) {
        interactor.addNewQuestion(question: question, medias: medias, topic: topic)
    }

    func didSubmitUpdatedQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft]) {
        interactor.updateQuestion(question: question, medias: medias)
    }

    func didDeleteQuestion(question: QuestionsGridQuestionDTO) {
        interactor.deleteQuestion(question: question)
    }
}

// MARK: - QuestionsGridPlayerEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridPlayerEditorDelegate {

    func didSubmitNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO) {
        interactor.addNewPlayer(player: player, game: game)
    }

    func didSubmitUpdatedPlayer(player: QuestionsGridPlayerDTO) {
        interactor.updatePlayer(player: player)
    }

    func didDeletePlayer(player: QuestionsGridPlayerDTO) {
        interactor.deletePlayer(player: player)
    }
}
