//
//  QuestionsGridQuestionEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorViewControllerProtocol: AnyObject {
    func displaySubmitQuestion(question: QuestionsGridQuestionModel)
}

final class QuestionsGridQuestionEditorViewController: UIHostingController<QuestionsGridQuestionEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    var onSubmit: ((QuestionsGridQuestionModel) -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridQuestionEditorInteractorProtocol
    private let viewModel: QuestionsGridQuestionEditorViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridQuestionEditorInteractorProtocol,
        viewModel: QuestionsGridQuestionEditorViewModel,
        rootView: QuestionsGridQuestionEditorView
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
        title = "Новый вопрос"
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitQuestion(
            text: viewModel.questionText,
            answer: viewModel.questionAnswer,
            price: viewModel.questionPrice
        )
    }
}

// MARK: - QuestionsGridQuestionEditorViewControllerProtocol

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewControllerProtocol {

    func displaySubmitQuestion(question: QuestionsGridQuestionModel) {
        onSubmit?(question)
    }
}

// MARK: - QuestionsGridQuestionEditorViewDelegate

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewDelegate {
}
