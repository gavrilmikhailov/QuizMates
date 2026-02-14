//
//  GameProcessViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol GameProcessViewControllerProtocol: AnyObject {
    func displayGameContent(
        title: String,
        topics: [(TopicDTO, [QuestionDTO])],
        prices: [Int],
        players: [PlayerDTO]
    )
    func displaySettings(
        topicFontSize: Double?,
        questionFontSize: Double?,
        playerNameFontSize: Double?,
        cellSize: Double?,
        cellColor: String?
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
        interactor.loadSettings()
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
            playerNameFontSize: viewModel.playerNameFontSize,
            cellSize: viewModel.cellSize,
            cellColor: viewModel.cellColor
        )
        onOpenSettings?(configuration, sender)
    }
}

// MARK: - GameProcessViewControllerProtocol

extension GameProcessViewController: GameProcessViewControllerProtocol {

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

    func displaySettings(
        topicFontSize: Double?,
        questionFontSize: Double?,
        playerNameFontSize: Double?,
        cellSize: Double?,
        cellColor: String?
    ) {
        if let topicFontSize, topicFontSize > 0  {
            viewModel.topicFontSize = CGFloat(topicFontSize)
        }
        if let questionFontSize, questionFontSize > 0 {
            viewModel.questionFontSize = CGFloat(questionFontSize)
        }
        if let playerNameFontSize, playerNameFontSize > 0 {
            viewModel.playerNameFontSize = playerNameFontSize
        }
        if let cellSize, cellSize > 0 {
            viewModel.cellSize = CGFloat(cellSize)
        }
        if let cellColor, let colorPreset = ColorPreset(rawValue: cellColor) {
            viewModel.cellColor = colorPreset
        }
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
        interactor.saveTopicFontSize(value: value)
        viewModel.topicFontSize = value
    }

    func didChangeQuestionFontSize(value: CGFloat) {
        interactor.saveQuestionFontSize(value: value)
        viewModel.questionFontSize = value
    }

    func didChangePlayerNameFontSize(value: CGFloat) {
        interactor.savePlayerNameFontSize(value: value)
        viewModel.playerNameFontSize = value
    }

    func didChangeCellSize(value: CGFloat) {
        interactor.saveCellSize(value: value)
        viewModel.cellSize = value
    }

    func didChangeCellColor(value: ColorPreset) {
        interactor.saveCellColor(value: value)
        viewModel.cellColor = value
    }
}
