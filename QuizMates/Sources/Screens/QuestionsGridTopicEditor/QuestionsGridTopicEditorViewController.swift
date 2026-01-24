//
//  QuestionsGridTopicEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridTopicEditorDelegate: AnyObject {
    func didSubmitTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel, isNew: Bool)
}

@MainActor
protocol QuestionsGridTopicEditorViewControllerProtocol: AnyObject {
    func displaySubmitTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel)
}

final class QuestionsGridTopicEditorViewController: UIHostingController<QuestionsGridTopicEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: QuestionsGridTopicEditorDelegate?

    // MARK: - Private properties

    private let interactor: QuestionsGridTopicEditorInteractorProtocol
    private let viewModel: QuestionsGridTopicEditorViewModel
    private let isNew: Bool

    // MARK: - Initializer

    init(
        interactor: QuestionsGridTopicEditorInteractorProtocol,
        viewModel: QuestionsGridTopicEditorViewModel,
        isNew: Bool,
        rootView: QuestionsGridTopicEditorView
    ) {
        self.interactor = interactor
        self.viewModel = viewModel
        self.isNew = isNew
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
        setupNavigationBar()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        title = "Новая тема"
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitTopic(name: viewModel.name)
    }
}

// MARK: - QuestionsGridTopicEditorViewControllerProtocol

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewControllerProtocol {

    func displaySubmitTopic(topic: QuestionsGridTopicModel, game: QuestionsGridGameModel) {
        delegate?.didSubmitTopic(topic: topic, game: game, isNew: isNew)
        onClose?()
    }
}

// MARK: - QuestionsGridTopicEditorViewDelegate

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewDelegate {
}
