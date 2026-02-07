//
//  QuestionsGridGameProcessQuestionViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessQuestionViewControllerProtocol: AnyObject {
    func displayQuestionContent(
        title: String,
        medias: [QuestionsGridMediaPreviewConfiguration],
        text: String,
        answer: String
    )
    func displayPlayers(players: [QuestionsGridPlayerDTO])
    func displayMarkQuestionAsAnswered()
    func displayError(text: String)
}

final class QuestionsGridGameProcessQuestionViewController: UIHostingController<QuestionsGridGameProcessQuestionView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGameProcessQuestionInteractorProtocol
    private let viewModel: QuestionsGridGameProcessQuestionViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameProcessQuestionInteractorProtocol,
        viewModel: QuestionsGridGameProcessQuestionViewModel,
        rootView: QuestionsGridGameProcessQuestionView
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
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = saveButton
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func saveButtonTapped() {
        interactor.markQuestionAsAnswered()
    }
}

// MARK: - QuestionsGridGameProcessQuestionViewControllerProtocol

extension QuestionsGridGameProcessQuestionViewController: QuestionsGridGameProcessQuestionViewControllerProtocol {

    func displayQuestionContent(
        title: String,
        medias: [QuestionsGridMediaPreviewConfiguration],
        text: String,
        answer: String
    ) {
        viewModel.title = title
        viewModel.medias = medias
        viewModel.text = text
        viewModel.answer = answer
    }

    func displayPlayers(players: [QuestionsGridPlayerDTO]) {
        viewModel.players = players
    }

    func displayMarkQuestionAsAnswered() {
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridGameProcessQuestionViewDelegate

extension QuestionsGridGameProcessQuestionViewController: QuestionsGridGameProcessQuestionViewDelegate {

    func didAssignScore(player: QuestionsGridPlayerDTO, isAddition: Bool) {
        interactor.assignScore(player: player, isAddition: isAddition)
    }
}
