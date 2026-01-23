//
//  QuestionsGridGamesListViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftUI

protocol QuestionsGridGamesListViewControllerProtocol: AnyObject {
    func displayGames(result: Result<[QuestionsGridGameModel], Error>)
}

final class QuestionsGridGamesListViewController: UIHostingController<QuestionsGridGamesListView> {

    // MARK: - Internal properties

    var onAddNewGame: (() -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGamesListInteractorProtocol
    private let viewModel: QuestionsGridGamesListViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGamesListInteractorProtocol,
        viewModel: QuestionsGridGamesListViewModel,
        rootView: QuestionsGridGamesListView
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.fetchGames()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = "Questions Grid"
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    @objc
    private func addButtonTapped() {
        onAddNewGame?()
    }
}

// MARK: - QuestionsGridGamesListViewControllerProtocol

extension QuestionsGridGamesListViewController: QuestionsGridGamesListViewControllerProtocol {

    func displayGames(result: Result<[QuestionsGridGameModel], Error>) {
        switch result {
        case .success(let games):
            viewModel.viewState = .normal
            viewModel.games = games
            navigationItem.rightBarButtonItem?.isHidden = games.isEmpty
        case .failure(let error):
            viewModel.viewState = .error(error.localizedDescription)
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}

// MARK: - QuestionsGridGamesListViewDelegate

extension QuestionsGridGamesListViewController: QuestionsGridGamesListViewDelegate {

    func didTapCreateNewGame() {
        print("TODO: Create game")
    }
}
