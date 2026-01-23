//
//  AppCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

final class AppCoordinator: BaseCoordinator {

    // MARK: - Internal properties

    var onFinish: (() -> Void)?

    // MARK: - Coordinator

    override func start() {
        showRoot()
    }

    // MARK: - Private methods

    private func showRoot() {
        let view = resolver.resolve(QuestionsGridGamesListViewController.self)!

        view.onAddNewGame = { [weak self] in
            self?.showNewGame()
        }
        view.onDeinit { [weak self] in
            self?.onFinish?()
        }

        router.setRootView(view)
    }

    private func showNewGame() {
        let view = resolver.resolve(QuestionsGridGameEditorViewController.self)!

        router.pushView(view, animated: true, hideBottomBar: true)
    }
}
