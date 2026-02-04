//
//  QuestionsGridGameProcessViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessViewControllerProtocol: AnyObject {
    func displayGameContent(
        title: String,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        prices: [Int],
        players: [QuestionsGridPlayerDTO]
    )
    func displayError(text: String)
}

final class QuestionsGridGameProcessViewController: UIHostingController<QuestionsGridGameProcessView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    var onOpenQuestion: ((QuestionsGridQuestionDTO) -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGameProcessInteractorProtocol
    private let viewModel: QuestionsGridGameProcessViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameProcessInteractorProtocol,
        viewModel: QuestionsGridGameProcessViewModel,
        rootView: QuestionsGridGameProcessView
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
        interactor.loadGameContent()
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
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }
}

// MARK: - QuestionsGridGameProcessViewControllerProtocol

extension QuestionsGridGameProcessViewController: QuestionsGridGameProcessViewControllerProtocol {

    func displayGameContent(
        title: String,
        topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])],
        prices: [Int],
        players: [QuestionsGridPlayerDTO]
    ) {
        self.title = title
        viewModel.prices = prices
        viewModel.topics = topics
        viewModel.players = players
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridGameProcessViewDelegate

extension QuestionsGridGameProcessViewController: QuestionsGridGameProcessViewDelegate {

    func didTapQuestion(dto: QuestionsGridQuestionDTO) {
        onOpenQuestion?(dto)
    }
}
