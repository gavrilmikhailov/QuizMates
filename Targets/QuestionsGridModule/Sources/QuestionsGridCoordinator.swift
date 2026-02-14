//
//  QuestionsGridCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import NavigationModule
import UIKit

@MainActor
public final class QuestionsGridCoordinator: BaseCoordinator {

    // MARK: - Coordinator

    public override func start() {
        showRoot()
    }

    // MARK: - Private methods

    private func showRoot() {
        let view = resolver.resolve(GamesListViewController.self)!

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

    private func showEditGame(game: GameDTO?) {
        let view: GameEditorViewController = if let game {
            resolver.resolve(GameEditorViewController.self, argument: game)!
        } else {
            resolver.resolve(GameEditorViewController.self)!
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
        view.onOpenGameProcess = { [weak self] game in
            self?.showGameProcess(game: game)
        }
        view.onOpenGameResults = { [weak self] players in
            self?.showGameResults(players: players, completion: nil)
        }

        router.pushView(view, animated: true, hideBottomBar: true)
    }

    private func showEditTopic(
        topic: TopicDTO?,
        game: GameDTO,
        delegate: TopicEditorDelegate?
    ) {
        let view: TopicEditorViewController = if let topic {
            resolver.resolve(TopicEditorViewController.self, arguments: game, topic)!
        } else {
            resolver.resolve(TopicEditorViewController.self, argument: game)!
        }

        view.delegate = delegate
        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }

    private func showEditQuestion(
        question: QuestionDTO?,
        topic: TopicDTO,
        delegate: QuestionEditorDelegate?
    ) {
        let view: QuestionEditorViewController = if let question {
            resolver.resolve(QuestionEditorViewController.self, arguments: topic, question)!
        } else {
            resolver.resolve(QuestionEditorViewController.self, argument: topic)!
        }
        view.delegate = delegate
        let nav = UINavigationController(rootViewController: view)

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }
        view.onOpenMediaPreview = { [weak self, weak view, weak nav] configuration in
            self?.showPhotoPreview(configuration: configuration, nav: nav, delegate: view)
        }

        router.presentView(nav, animated: true, completion: nil)
    }

    private func showPhotoPreview(
        configuration: MediaPreviewConfiguration,
        nav: UINavigationController?,
        delegate: MediaPreviewDelegate?
    ) {
        let view = resolver.resolve(MediaPreviewViewController.self, argument: configuration)!
        view.delegate = delegate
        view.onClose = { [weak nav] in
            nav?.popViewController(animated: true)
        }
        nav?.pushViewController(view, animated: true)
    }

    private func showEditPlayer(
        game: GameDTO,
        player: PlayerDTO?,
        delegate: PlayerEditorDelegate?
    ) {
        let view: PlayerEditorViewController = if let player {
            resolver.resolve(PlayerEditorViewController.self, arguments: game, player)!
        } else {
            resolver.resolve(PlayerEditorViewController.self, argument: game)!
        }

        view.delegate = delegate
        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }

    private func showGameProcess(game: GameDTO) {
        let view = resolver.resolve(GameProcessViewController.self, argument: game)!

        view.onOpenQuestion = { [weak self] topic, question, players in
            self?.showGameProcessQuestion(topic: topic, question: question, players: players)
        }
        view.onOpenSettings = { [weak self, weak view] configuration, sourceItem in
            self?.showGameProcessSettings(
                configuration: configuration,
                sourceItem: sourceItem,
                delegate: view,
                presentingView: view
            )
        }
        view.onFinish = { [weak self] players in
            self?.showGameResults(players: players) {
                self?.router.popView(animated: false)
            }
        }

        router.pushView(view, animated: true, hideBottomBar: true)
    }

    private func showGameProcessQuestion(
        topic: TopicDTO,
        question: QuestionDTO,
        players: [PlayerDTO]
    ) {
        let view = resolver.resolve(
            GameProcessQuestionViewController.self,
            arguments: topic, question, players
        )!

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        router.presentView(nav, animated: true, completion: nil)
    }

    private func showGameProcessSettings(
        configuration: GameProcessSettingsConfiguration,
        sourceItem: UIPopoverPresentationControllerSourceItem,
        delegate: GameProcessSettingsDelegate?,
        presentingView: (UIViewController & UIPopoverPresentationControllerDelegate)?
    ) {
        let view = resolver.resolve(GameProcessSettingsViewController.self, arguments: configuration, delegate)!
        view.modalPresentationStyle = .popover
        view.preferredContentSize = CGSize(width: 300, height: 500)

        if let popover = view.popoverPresentationController {
            popover.sourceItem = sourceItem
            popover.delegate = presentingView
            popover.backgroundColor = .systemBackground
        }

        presentingView?.present(view, animated: true)
    }

    private func showGameResults(players: [PlayerDTO], completion: (() -> Void)?) {
        let view = resolver.resolve(GameResultsViewController.self, argument: players)!

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        router.presentView(nav, animated: true, completion: completion)
    }
}
