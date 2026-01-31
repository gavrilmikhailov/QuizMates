//
//  AppCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

@MainActor
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
            self?.showEditGame(game: nil)
        }
        view.onOpenGame = { [weak self] game in
            self?.showEditGame(game: game)
        }
        view.onDeinit { [weak self] in
            self?.onFinish?()
        }

        router.setRootView(view)
    }

    private func showEditGame(game: QuestionsGridGameDTO?) {
        let view: QuestionsGridGameEditorViewController = if let game {
            resolver.resolve(QuestionsGridGameEditorViewController.self, argument: game)!
        } else {
            resolver.resolve(QuestionsGridGameEditorViewController.self)!
        }

        view.onEditTopic = { [weak self, weak view] topic, game in
            self?.showEditTopic(topic: topic, game: game, delegate: view)
        }
        view.onEditQuestion = { [weak self, weak view] question, topic in
            self?.showEditQuestion(question: question, topic: topic, delegate: view)
        }
        view.onEditPlayer = { [weak self, weak view] player, game in
            self?.showEditPlayer(game: game, player: player, delegate: view)
        }

        router.pushView(view, animated: true, hideBottomBar: true)
    }

    private func showEditTopic(
        topic: QuestionsGridTopicDTO?,
        game: QuestionsGridGameDTO,
        delegate: QuestionsGridTopicEditorDelegate?
    ) {
        let view: QuestionsGridTopicEditorViewController = if let topic {
            resolver.resolve(QuestionsGridTopicEditorViewController.self, arguments: game, topic)!
        } else {
            resolver.resolve(QuestionsGridTopicEditorViewController.self, argument: game)!
        }

        view.delegate = delegate
        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }

    private func showEditQuestion(
        question: QuestionsGridQuestionDTO?,
        topic: QuestionsGridTopicDTO,
        delegate: QuestionsGridQuestionEditorDelegate?
    ) {
        let view: QuestionsGridQuestionEditorViewController = if let question {
            resolver.resolve(QuestionsGridQuestionEditorViewController.self, arguments: topic, question)!
        } else {
            resolver.resolve(QuestionsGridQuestionEditorViewController.self, argument: topic)!
        }
        view.delegate = delegate
        let nav = UINavigationController(rootViewController: view)

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }
        view.onOpenMediaPreview = { [weak self, weak view, weak nav] mode in
            self?.showPhotoPreview(mode: mode, nav: nav, delegate: view)
        }

        router.presentView(nav, animated: true, completion: nil)
    }

    private func showPhotoPreview(
        mode: QuestionsGridMediaPreviewMode,
        nav: UINavigationController?,
        delegate: QuestionsGridMediaPreviewDelegate?
    ) {
        let view = resolver.resolve(QuestionsGridMediaPreviewViewController.self, argument: mode)!
        view.delegate = delegate
        view.onClose = { [weak nav] in
            nav?.popViewController(animated: true)
        }
        nav?.pushViewController(view, animated: true)
    }

    private func showEditPlayer(
        game: QuestionsGridGameDTO,
        player: QuestionsGridPlayerDTO?,
        delegate: QuestionsGridPlayerEditorDelegate?
    ) {
        let view: QuestionsGridPlayerEditorViewController = if let player {
            resolver.resolve(QuestionsGridPlayerEditorViewController.self, arguments: game, player)!
        } else {
            resolver.resolve(QuestionsGridPlayerEditorViewController.self, argument: game)!
        }

        view.delegate = delegate
        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }
}
