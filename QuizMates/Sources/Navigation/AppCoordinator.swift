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
            self?.showNewGame()
        }
        view.onOpenGame = { [weak self] model in
            self?.showEditGame(model: model)
        }
        view.onDeinit { [weak self] in
            self?.onFinish?()
        }

        router.setRootView(view)
    }

    private func showNewGame() {
        let view = resolver.resolve(QuestionsGridGameEditorViewController.self)!

        view.onAddNewTopic = { [weak self, weak view] in
            self?.showNewTopic { topic in
                view?.addNewTopic(topic: topic)
            }
        }
        view.onAddNewQuestion = { [weak self, weak view] topic in
            self?.showEditQuestion(question: nil, topic: topic, delegate: view)
        }

        router.pushView(view, animated: true, hideBottomBar: true)
    }

    private func showEditGame(model: QuestionsGridGameModel) {
        let view = resolver.resolve(QuestionsGridGameEditorViewController.self, argument: model)!

        view.onAddNewTopic = { [weak self, weak view] in
            self?.showNewTopic { topic in
                view?.addNewTopic(topic: topic)
            }
        }
        view.onAddNewQuestion = { [weak self, weak view] topic in
            self?.showEditQuestion(question: nil, topic: topic, delegate: view)
        }
        view.onEditQuestion = { [weak self, weak view] question, topic in
            self?.showEditQuestion(question: question, topic: topic, delegate: view)
        }

        router.pushView(view, animated: true, hideBottomBar: true)
    }

    private func showNewTopic(onSubmit: ((QuestionsGridTopicModel) -> Void)?) {
        let view = resolver.resolve(QuestionsGridTopicEditorViewController.self)!

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }
        view.onSubmit = { [weak self] topic in
            self?.router.dismissView(animated: true) {
                onSubmit?(topic)
            }
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }

    private func showEditQuestion(
        question: QuestionsGridQuestionModel?,
        topic: QuestionsGridTopicModel,
        delegate: QuestionsGridQuestionEditorDelegate?
    ) {
        let view: QuestionsGridQuestionEditorViewController = if let question {
            resolver.resolve(QuestionsGridQuestionEditorViewController.self, arguments: topic, question)!
        } else {
            resolver.resolve(QuestionsGridQuestionEditorViewController.self, argument: topic)!
        }
        view.delegate = delegate

        view.onClose = { [weak self] in
            self?.router.dismissView(animated: true, completion: nil)
        }

        let nav = UINavigationController(rootViewController: view)
        router.presentView(nav, animated: true, completion: nil)
    }
}
