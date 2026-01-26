//
//  QuestionsGridQuestionEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorDelegate: AnyObject {
    func didSubmitQuestion(question: QuestionsGridQuestionDraft, topic: QuestionsGridTopicDTO)
    func didSubmitQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO)
    func didDeleteQuestion(question: QuestionsGridQuestionDTO)
}

@MainActor
protocol QuestionsGridQuestionEditorViewControllerProtocol: AnyObject {
    func displayQuestionLoading()
    func displayQuestionContent(question: QuestionsGridQuestionDTO)
    func displaySubmitQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO)
    func displayDeleteQuestion(question: QuestionsGridQuestionDTO)
    func displayError(text: String)
}

final class QuestionsGridQuestionEditorViewController: UIHostingController<QuestionsGridQuestionEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: QuestionsGridQuestionEditorDelegate?

    // MARK: - Private properties

    private let interactor: QuestionsGridQuestionEditorInteractorProtocol
    private let viewModel: QuestionsGridQuestionEditorViewModel
    private let isNew: Bool

    // MARK: - Initializer

    init(
        interactor: QuestionsGridQuestionEditorInteractorProtocol,
        viewModel: QuestionsGridQuestionEditorViewModel,
        isNew: Bool,
        rootView: QuestionsGridQuestionEditorView
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
        interactor.createNewQuestionIfNeeded()
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
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        if isNew {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        }
        title = "Новый вопрос"
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить этот вопрос?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteQuestion()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
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

    func displayQuestionLoading() {
        interactor.loadQuestionContent()
    }

    func displayQuestionContent(question: QuestionsGridQuestionDTO) {
        viewModel.questionText = question.text
        viewModel.questionAnswer = question.answer
        viewModel.questionPrice = question.price
    }

    func displaySubmitQuestion(question: QuestionsGridQuestionDTO, topic: QuestionsGridTopicDTO) {
        delegate?.didSubmitQuestion(question: question, topic: topic)
        onClose?()
    }

    func displayDeleteQuestion(question: QuestionsGridQuestionDTO) {
        delegate?.didDeleteQuestion(question: question)
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridQuestionEditorViewDelegate

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewDelegate {
}
