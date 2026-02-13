//
//  TopicEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol TopicEditorDelegate: AnyObject {
    func didSubmitNewTopic(topic: TopicDraft, game: GameDTO)
    func didSubmitUpdatedTopic(topic: TopicDTO)
    func didDeleteTopic(topic: TopicDTO)
}

@MainActor
protocol TopicEditorViewControllerProtocol: AnyObject {
    func displayContentLoading()
    func displayContent(name: String)
    func displaySubmitNewTopic(topic: TopicDraft, game: GameDTO)
    func displaySubmitUpdatedTopic(topic: TopicDTO)
    func displayDeleteTopic(topic: TopicDTO)
    func displayError(text: String)
}

final class TopicEditorViewController: UIHostingController<TopicEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: TopicEditorDelegate?

    // MARK: - Private properties

    private let interactor: TopicEditorInteractorProtocol
    private let viewModel: TopicEditorViewModel
    private let isNew: Bool

    // MARK: - Initializer

    init(
        interactor: TopicEditorInteractorProtocol,
        viewModel: TopicEditorViewModel,
        isNew: Bool,
        rootView: TopicEditorView
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
        navigationController?.navigationBar.prefersLargeTitles = isNew
        title = isNew ? Strings.newTopic : ""
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
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: Strings.deleteTopicTitle,
            message: Strings.deleteTopicWarning,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: Strings.deleteTopicAction, style: .destructive) { [weak self] _ in
            self?.interactor.deleteTopic()
        }
        let cancelAction = UIAlertAction(title: Strings.deleteTopicCancel, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitTopic(name: viewModel.name)
    }
}

// MARK: - TopicEditorViewControllerProtocol

extension TopicEditorViewController: TopicEditorViewControllerProtocol {

    func displayContentLoading() {
        interactor.loadTopicContent()
    }

    func displayContent(name: String) {
        viewModel.name = name
    }

    func displaySubmitNewTopic(topic: TopicDraft, game: GameDTO) {
        delegate?.didSubmitNewTopic(topic: topic, game: game)
        onClose?()
    }

    func displaySubmitUpdatedTopic(topic: TopicDTO) {
        delegate?.didSubmitUpdatedTopic(topic: topic)
        onClose?()
    }

    func displayDeleteTopic(topic: TopicDTO) {
        delegate?.didDeleteTopic(topic: topic)
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: Strings.errorTitle, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.errorAction, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TopicEditorViewDelegate

extension TopicEditorViewController: TopicEditorViewDelegate {
}
