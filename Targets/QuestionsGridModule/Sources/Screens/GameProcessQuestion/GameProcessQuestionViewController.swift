//
//  GameProcessQuestionViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

@MainActor
protocol GameProcessQuestionViewControllerProtocol: AnyObject {
    func displayQuestionContent(
        title: String,
        medias: [MediaPreviewConfiguration],
        text: String,
        answer: String
    )
    func displayPlayers(players: [PlayerDTO])
    func displayMarkQuestionAsAnswered()
    func displayError(text: String)
}

final class GameProcessQuestionViewController: UIHostingController<GameProcessQuestionView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?

    // MARK: - Private properties

    private let interactor: GameProcessQuestionInteractorProtocol
    private let viewModel: GameProcessQuestionViewModel

    // MARK: - Initializer

    init(
        interactor: GameProcessQuestionInteractorProtocol,
        viewModel: GameProcessQuestionViewModel,
        rootView: GameProcessQuestionView
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
        interactor.loadQuestionContent()
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
        navigationController?.navigationBar.prefersLargeTitles = false

        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped(_:))
        )
        navigationItem.rightBarButtonItem = settingsButton
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItems = [saveButton, settingsButton]
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func settingsButtonTapped(_ sender: UIBarButtonItem) {
    }

    @objc
    private func saveButtonTapped() {
        interactor.markQuestionAsAnswered()
    }
}

// MARK: - GameProcessQuestionViewControllerProtocol

extension GameProcessQuestionViewController: GameProcessQuestionViewControllerProtocol {

    func displayQuestionContent(
        title: String,
        medias: [MediaPreviewConfiguration],
        text: String,
        answer: String
    ) {
        self.title = title
        viewModel.medias = medias
        viewModel.text = text
        viewModel.answer = answer
    }

    func displayPlayers(players: [PlayerDTO]) {
        viewModel.players = players
    }

    func displayMarkQuestionAsAnswered() {
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: Strings.errorTitle, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.errorAction, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - GameProcessQuestionViewDelegate

extension GameProcessQuestionViewController: GameProcessQuestionViewDelegate {

    func didAssignScore(player: PlayerDTO, isAddition: Bool) {
        interactor.assignScore(player: player, isAddition: isAddition)
    }
}
