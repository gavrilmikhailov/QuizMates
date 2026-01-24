//
//  QuestionsGridGameEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameEditorViewControllerProtocol: AnyObject {
    func displayGameName(name: String)
    func displayGameTopics(topics: [QuestionsGridTopicModel])
}

final class QuestionsGridGameEditorViewController: UIHostingController<QuestionsGridGameEditorView> {

    // MARK: - Internal properties

    var onAddNewTopic: ((QuestionsGridGameModel) -> Void)?
    var onEditTopic: ((QuestionsGridTopicModel, QuestionsGridGameModel) -> Void)?
    var onAddNewQuestion: ((QuestionsGridTopicModel) -> Void)?
    var onEditQuestion: ((QuestionsGridQuestionModel, QuestionsGridTopicModel) -> Void)?

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
        interactor.loadGameName()
        interactor.loadGameTopics()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Internal methods

    func addNewTopic(topic: QuestionsGridTopicModel) {

    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - QuestionsGridGameEditorViewControllerProtocol

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewControllerProtocol {

    func displayGameName(name: String) {
        viewModel.name = name
    }

    func displayGameTopics(topics: [QuestionsGridTopicModel]) {
        viewModel.topics = topics
    }
}

// MARK: - QuestionsGridGameEditorViewDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewDelegate {

    func didSumbitNewGameName(name: String) {
        interactor.updateGameName(name: name)
    }

    func didTapCreateNewTopic() {
        onAddNewTopic?(interactor.game)
    }

    func didTapEditTopic(topic: QuestionsGridTopicModel) {
        onEditTopic?(topic, interactor.game)
    }

    func didTapCreateNewQuestion(topic: QuestionsGridTopicModel) {
        onAddNewQuestion?(topic)
    }

    func didTapEditQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel) {
        onEditQuestion?(question, topic)
    }
}

// MARK: - QuestionsGridTopicEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridTopicEditorDelegate {

    func didSubmitTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel, isNew: Bool) {
        if isNew {
            interactor.addNewTopic(topic: topic, game: game)
        } else {
            interactor.updateTopic(topic: topic)
        }
        interactor.loadGameTopics()
    }
}

// MARK: - QuestionsGridQuestionEditorDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridQuestionEditorDelegate {

    func didSubmitQuestion(question: QuestionsGridQuestionModel, topic: QuestionsGridTopicModel, isNew: Bool) {
        if isNew {
            interactor.addNewQuestion(question: question, topic: topic)
        } else {
            interactor.updateQuestion(question: question)
        }
        interactor.loadGameTopics()
    }
}
