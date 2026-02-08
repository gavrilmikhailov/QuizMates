//
//  GameResultsViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import SwiftUI

@MainActor
protocol GameResultsViewControllerProtocol: AnyObject {
    func displayPlayers(results: [GameResult])
}

final class GameResultsViewController: UIHostingController<GameResultsView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?

    // MARK: - Private properties

    private let interactor: GameResultsInteractorProtocol
    private let viewModel: GameResultsViewModel

    // MARK: - Initializer

    init(interactor: GameResultsInteractorProtocol, viewModel: GameResultsViewModel, rootView: GameResultsView) {
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
        interactor.loadPlayers()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - GameResultsViewControllerProtocol

extension GameResultsViewController: GameResultsViewControllerProtocol {

    func displayPlayers(results: [GameResult]) {
        viewModel.results = results
    }
}

// MARK: - GameResultsViewDelegate

extension GameResultsViewController: GameResultsViewDelegate {

    func didTapOk() {
        onClose?()
    }
}
