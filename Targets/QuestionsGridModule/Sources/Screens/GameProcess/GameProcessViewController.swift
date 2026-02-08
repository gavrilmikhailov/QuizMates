//
//  GameProcessViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol ViewControllerProtocol: AnyObject {
    func displayGameContent(
        title: String,
        topics: [(TopicDTO, [QuestionDTO])],
        prices: [Int],
        players: [PlayerDTO]
    )
    func displayNavigateToQuestion(
        topic: TopicDTO,
        question: QuestionDTO,
        players: [PlayerDTO]
    )
    func displayGameResults(players: [PlayerDTO])
    func displayError(text: String)
}

final class GameProcessViewController: UIHostingController<GameProcessView> {

    // MARK: - Internal properties

    var onOpenQuestion: ((TopicDTO, QuestionDTO, [PlayerDTO]) -> Void)?
    var onFinish: (([PlayerDTO]) -> Void)?

    // MARK: - Private properties

    private let interactor: GameProcessInteractorProtocol
    private let viewModel: GameProcessViewModel

    // MARK: - Initializer

    init(
        interactor: GameProcessInteractorProtocol,
        viewModel: GameProcessViewModel,
        rootView: GameProcessView
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
        interactor.loadGameContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.checkGameResults()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - ViewControllerProtocol

extension GameProcessViewController: ViewControllerProtocol {

    func displayGameContent(
        title: String,
        topics: [(TopicDTO, [QuestionDTO])],
        prices: [Int],
        players: [PlayerDTO]
    ) {
        viewModel.title = title
        viewModel.prices = prices
        viewModel.topics = topics
        viewModel.players = players
    }

    func displayNavigateToQuestion(
        topic: TopicDTO,
        question: QuestionDTO,
        players: [PlayerDTO]
    ) {
        onOpenQuestion?(topic, question, players)
    }

    func displayGameResults(players: [PlayerDTO]) {
        onFinish?(players)
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - GameProcessViewDelegate

extension GameProcessViewController: GameProcessViewDelegate {

    func didTapQuestion(topic: TopicDTO, question: QuestionDTO) {
        interactor.navigateToQuestion(topic: topic, question: question)
    }
}
