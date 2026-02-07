//
//  GamesListViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftUI

@MainActor
protocol GamesListViewControllerProtocol: AnyObject {
    func displayGames(result: Result<[GameDTO], Error>)
}

final class GamesListViewController: UIHostingController<GamesListView> {

    // MARK: - Internal properties

    var onAddNewGame: (() -> Void)?
    var onOpenGame: ((GameDTO) -> Void)?

    // MARK: - Private properties

    private let interactor: GamesListInteractorProtocol
    private let viewModel: GamesListViewModel

    // MARK: - Initializer

    init(
        interactor: GamesListInteractorProtocol,
        viewModel: GamesListViewModel,
        rootView: GamesListView
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

// MARK: - GamesListViewControllerProtocol

extension GamesListViewController: GamesListViewControllerProtocol {

    func displayGames(result: Result<[GameDTO], Error>) {
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

// MARK: - GamesListViewDelegate

extension GamesListViewController: GamesListViewDelegate {

    func didTapCreateNewGame() {
        onAddNewGame?()
    }

    func didTapGame(dto: GameDTO) {
        onOpenGame?(dto)
    }

    func didSwipeToDeleteGame(dto: GameDTO) {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить эту игру?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteGame(dto: dto)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    func didPullToRefresh() {
        interactor.fetchGames()
    }
}
