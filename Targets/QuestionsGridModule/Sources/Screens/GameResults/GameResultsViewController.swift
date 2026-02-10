//
//  GameResultsViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import SwiftUI
import Vortex

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
    private var didAppear: Bool = false

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !didAppear {
            showVictoryEffect()
        }
        didAppear = true
    }

    // MARK: - Private methods

    private func configureAppearance() {
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .systemBackground
    }

    private func showVictoryEffect() {
        viewModel.confettiToggle.toggle()
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
