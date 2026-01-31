//
//  QuestionsGridPlayerEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridPlayerEditorDelegate: AnyObject {
    func didSubmitNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO)
    func didSubmitUpdatedPlayer(player: QuestionsGridPlayerDTO)
    func didDeletePlayer(player: QuestionsGridPlayerDTO)
}

@MainActor
protocol QuestionsGridPlayerEditorViewControllerProtocol: AnyObject {
    func displaySumbitNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO)
    func displaySumbitUpdatedPlayer(player: QuestionsGridPlayerDTO)
    func displayDeletePlayer(player: QuestionsGridPlayerDTO)
}

final class QuestionsGridPlayerEditorViewController: UIHostingController<QuestionsGridPlayerEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: QuestionsGridPlayerEditorDelegate?

    // MARK: - Private properties

    private let interactor: QuestionsGridPlayerEditorInteractor
    private let viewModel: QuestionsGridPlayerEditorViewModel
    private let mode: QuestionsGridPlayerEditorMode

    // MARK: - Initializer

    init(
        interactor: QuestionsGridPlayerEditorInteractor,
        viewModel: QuestionsGridPlayerEditorViewModel,
        mode: QuestionsGridPlayerEditorMode,
        rootView: QuestionsGridPlayerEditorView
    ) {
        self.interactor = interactor
        self.viewModel = viewModel
        self.mode = mode
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        interactor.loadPlayerContent()
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
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        switch mode {
        case .createNewPlayer:
            title = "Новый игрок"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = saveButton
        case .editExistingPlayer:
            title = nil
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItems = [deleteButton, saveButton]
        }
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить этого игрока?",
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deletePlayer()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitPlayer(emoji: viewModel.emoji, name: viewModel.name)
    }
}

// MARK: - QuestionsGridPlayerEditorViewControllerProtocol

extension QuestionsGridPlayerEditorViewController: QuestionsGridPlayerEditorViewControllerProtocol {

    func displaySumbitNewPlayer(player: QuestionsGridPlayerDraft, game: QuestionsGridGameDTO) {
        delegate?.didSubmitNewPlayer(player: player, game: game)
        onClose?()
    }

    func displaySumbitUpdatedPlayer(player: QuestionsGridPlayerDTO) {
        delegate?.didSubmitUpdatedPlayer(player: player)
        onClose?()
    }

    func displayDeletePlayer(player: QuestionsGridPlayerDTO) {
        delegate?.didDeletePlayer(player: player)
        onClose?()
    }
}

// MARK: - QuestionsGridPlayerEditorViewDelegate

extension QuestionsGridPlayerEditorViewController: QuestionsGridPlayerEditorViewDelegate {
}
