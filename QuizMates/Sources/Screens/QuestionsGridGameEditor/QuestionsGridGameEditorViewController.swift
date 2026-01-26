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
    func displayGameContent(game: QuestionsGridGameDTO, topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])])
    func displayNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO)
    func displayNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO)
    func displayError(text: String)
}

final class QuestionsGridGameEditorViewController: UIHostingController<QuestionsGridGameEditorView> {

    // MARK: - Internal properties

    var onEditTopic: ((QuestionsGridTopicDTO?, QuestionsGridGameDTO) -> Void)?
    var onEditQuestion: ((QuestionsGridQuestionDTO?, QuestionsGridTopicDTO) -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGameEditorInteractorProtocol
    private let viewModel: QuestionsGridGameEditorViewModel

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
        interactor.createNewGameIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - QuestionsGridGameEditorViewControllerProtocol

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewControllerProtocol {

    func displayGameLoading() {
        interactor.loadGameContent()
    }

    func displayGameContent(game: QuestionsGridGameDTO, topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])]) {
        viewModel.name = game.name
        viewModel.topics = topics
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func displayNavigateToEditTopic(topic: QuestionsGridTopicDTO?, game: QuestionsGridGameDTO) {
        onEditTopic?(topic, game)
    }

    func displayNavigateToEditQuestion(question: QuestionsGridQuestionDTO?, topic: QuestionsGridTopicDTO) {
        onEditQuestion?(question, topic)
    }
}

// MARK: - QuestionsGridGameEditorViewDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewDelegate {

    func didSumbitNewGameName(name: String) {
        interactor.updateGameName(name: name)
    }

    func didTapCreateNewTopic() {
        interactor.navigateToEditTopic(topic: nil)
    }

    func didTapEditTopic(topic: QuestionsGridTopicDTO) {
        interactor.navigateToEditTopic(topic: topic)
    }

    func didTapDeleteTopic(topic: QuestionsGridTopicDTO) {
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

    func didTapCreateNewQuestion(topic: QuestionsGridTopicDTO) {
        interactor.navigateToCreateNewQuestion(topic: topic)
    }

    func didTapEditQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO) {
        interactor.navigateToEditQuestion(question: question, topic: topic)
    }

    func didTapDeleteQuestion(question: QuestionsGridQuestionDTO) {
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

// MARK: - QuestionsGridTopicEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridTopicEditorDelegate {

    func didSubmitTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) {
        // interactor.addNewTopic(topic: topic, game: game)
        interactor.loadGameContent()
    }

    func didSubmitTopic(topic: QuestionsGridTopicDTO) {
        // interactor.updateTopic(topic: topic)
        interactor.loadGameContent()
    }

    func didDeleteTopic(topic: QuestionsGridTopicDTO) {
        // interactor.deleteTopic(topic: topic)
        interactor.loadGameContent()
    }
}

// MARK: - QuestionsGridQuestionEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridQuestionEditorDelegate {

    func didSubmitQuestion(question: QuestionsGridQuestionDraft, topic: QuestionsGridTopicDTO) {
        interactor.addNewQuestion(question: question, topic: topic)
    }

    func didSubmitQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO) {
        interactor.updateQuestion(question: question)
    }

    func didDeleteQuestion(question: QuestionsGridQuestionDTO) {
        interactor.deleteQuestion(question: question)
    }
}
