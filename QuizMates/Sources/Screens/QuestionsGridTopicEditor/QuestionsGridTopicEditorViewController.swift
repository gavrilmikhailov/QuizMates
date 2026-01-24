//
//  QuestionsGridTopicEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridTopicEditorViewControllerProtocol: AnyObject {
    func displaySubmitNewTopicName(topic: QuestionsGridTopicModel)
}

final class QuestionsGridTopicEditorViewController: UIHostingController<QuestionsGridTopicEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    var onSubmit: ((QuestionsGridTopicModel) -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridTopicEditorInteractorProtocol
    private let viewModel: QuestionsGridTopicEditorViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridTopicEditorInteractorProtocol,
        viewModel: QuestionsGridTopicEditorViewModel,
        rootView: QuestionsGridTopicEditorView
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
        didSubmitNewTopicName()
    }
}

// MARK: - QuestionsGridTopicEditorViewControllerProtocol

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewControllerProtocol {

    func displaySubmitNewTopicName(topic: QuestionsGridTopicModel) {
        onSubmit?(topic)
    }
}

// MARK: - QuestionsGridTopicEditorViewDelegate

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewDelegate {

    func didSubmitNewTopicName() {
        interactor.updateTopicName(name: viewModel.name)
    }
}
