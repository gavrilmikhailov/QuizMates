//
//  PlayerEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

@MainActor
protocol PlayerEditorDelegate: AnyObject {
    func didSubmitNewPlayer(player: PlayerDraft, game: GameDTO)
    func didSubmitUpdatedPlayer(player: PlayerDTO)
    func didDeletePlayer(player: PlayerDTO)
}

@MainActor
protocol PlayerEditorViewControllerProtocol: AnyObject {
    func displayContent(emoji: String, name: String)
    func displaySumbitNewPlayer(player: PlayerDraft, game: GameDTO)
    func displaySumbitUpdatedPlayer(player: PlayerDTO)
    func displayDeletePlayer(player: PlayerDTO)
}

final class PlayerEditorViewController: UIHostingController<PlayerEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: PlayerEditorDelegate?

    // MARK: - Private properties

    private let interactor: PlayerEditorInteractor
    private let viewModel: PlayerEditorViewModel
    private let mode: PlayerEditorMode

    // MARK: - Initializer

    init(
        interactor: PlayerEditorInteractor,
        viewModel: PlayerEditorViewModel,
        mode: PlayerEditorMode,
        rootView: PlayerEditorView
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

// MARK: - PlayerEditorViewControllerProtocol

extension PlayerEditorViewController: PlayerEditorViewControllerProtocol {

    func displayContent(emoji: String, name: String) {
        viewModel.emoji = emoji
        viewModel.name = name
    }

    func displaySumbitNewPlayer(player: PlayerDraft, game: GameDTO) {
        delegate?.didSubmitNewPlayer(player: player, game: game)
        onClose?()
    }

    func displaySumbitUpdatedPlayer(player: PlayerDTO) {
        delegate?.didSubmitUpdatedPlayer(player: player)
        onClose?()
    }

    func displayDeletePlayer(player: PlayerDTO) {
        delegate?.didDeletePlayer(player: player)
        onClose?()
    }
}

// MARK: - PlayerEditorViewDelegate

extension PlayerEditorViewController: PlayerEditorViewDelegate {
}
