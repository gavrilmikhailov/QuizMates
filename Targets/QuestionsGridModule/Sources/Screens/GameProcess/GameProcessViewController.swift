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
    var onOpenSettings: ((GameProcessSettingsConfiguration, UIPopoverPresentationControllerSourceItem) -> Void)?
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
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped(_:))
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc
    private func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let configuration = GameProcessSettingsConfiguration(
            topicFontSize: viewModel.topicFontSize,
            questionFontSize: viewModel.questionFontSize,
            cellSize: viewModel.cellSize,
            cellColor: viewModel.cellColor
        )
        onOpenSettings?(configuration, sender)
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
        let alert = UIAlertController(title: Strings.errorTitle, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.errorAction, style: .default, handler: nil)
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

// MARK: - UIPopoverPresentationControllerDelegate

extension GameProcessViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - GameProcessSettingsDelegate

extension GameProcessViewController: GameProcessSettingsDelegate {

    func didChangeTopicFontSize(value: CGFloat) {
        viewModel.topicFontSize = value
    }

    func didChangeQuestionFontSize(value: CGFloat) {
        viewModel.questionFontSize = value
    }

    func didChangeCellSize(value: CGFloat) {
        viewModel.cellSize = value
    }

    func didChangeCellColor(value: Color) {
        viewModel.cellColor = value
    }
}
