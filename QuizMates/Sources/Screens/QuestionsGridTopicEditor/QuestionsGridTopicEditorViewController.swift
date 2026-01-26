//
//  QuestionsGridTopicEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridTopicEditorDelegate: AnyObject {
    func didSubmitNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO)
    func didSubmitUpdatedTopic(topic: QuestionsGridTopicDTO)
    func didDeleteTopic(topic: QuestionsGridTopicDTO)
}

@MainActor
protocol QuestionsGridTopicEditorViewControllerProtocol: AnyObject {
    func displayContentLoading()
    func displayContent(name: String)
    func displaySubmitNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO)
    func displaySubmitUpdatedTopic(topic: QuestionsGridTopicDTO)
    func displayDeleteTopic(topic: QuestionsGridTopicDTO)
    func displayError(text: String)
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
        interactor.loadTopicContent()
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
        title = "Новая тема"
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить эту тему?\nВсе вопросы из этой темы будут также удалены",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteTopic()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitTopic(name: viewModel.name)
    }
}

// MARK: - QuestionsGridTopicEditorViewControllerProtocol

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewControllerProtocol {

    func displayContentLoading() {
        interactor.loadTopicContent()
    }

    func displayContent(name: String) {
        viewModel.name = name
    }

    func displaySubmitNewTopic(topic: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) {
        delegate?.didSubmitNewTopic(topic: topic, game: game)
        onClose?()
    }

    func displaySubmitUpdatedTopic(topic: QuestionsGridTopicDTO) {
        delegate?.didSubmitUpdatedTopic(topic: topic)
        onClose?()
    }

    func displayDeleteTopic(topic: QuestionsGridTopicDTO) {
        delegate?.didDeleteTopic(topic: topic)
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridTopicEditorViewDelegate

extension QuestionsGridTopicEditorViewController: QuestionsGridTopicEditorViewDelegate {
}
