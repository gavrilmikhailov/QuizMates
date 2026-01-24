//
//  QuestionsGridAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData
@preconcurrency import Swinject

final class QuestionsGridAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        MainActor.assumeIsolated {
            container.register(QuestionsGridGamesListViewController.self) { resolver in
                let context = resolver.resolve(ModelContext.self)!
                let presenter = QuestionsGridGamesListPresenter()
                let interactor = QuestionsGridGamesListInteractor(presenter: presenter, context: context)
                let viewModel = QuestionsGridGamesListViewModel()
                let view = QuestionsGridGamesListViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGamesListView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            container.register(QuestionsGridGameEditorViewController.self) { resolver in
                let context = resolver.resolve(ModelContext.self)!
                let presenter = QuestionsGridGameEditorPresenter()
                let interactor = QuestionsGridGameEditorInteractor(presenter: presenter, context: context, model: nil)
                let viewModel = QuestionsGridGameEditorViewModel()
                let view = QuestionsGridGameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            container.register(QuestionsGridGameEditorViewController.self) { (resolver: Resolver, model: QuestionsGridGameModel) in
                let context = resolver.resolve(ModelContext.self)!
                let presenter = QuestionsGridGameEditorPresenter()
                let interactor = QuestionsGridGameEditorInteractor(presenter: presenter, context: context, model: model)
                let viewModel = QuestionsGridGameEditorViewModel()
                let view = QuestionsGridGameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            container.register(QuestionsGridTopicEditorViewController.self) { resolver in
                let interactor = QuestionsGridTopicEditorInteractor()
                let viewModel = QuestionsGridTopicEditorViewModel()
                let view = QuestionsGridTopicEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridTopicEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            container.register(QuestionsGridQuestionEditorViewController.self) { (resolver: Resolver, topic: QuestionsGridTopicModel) in
                let interactor = QuestionsGridQuestionEditorInteractor(topic: topic, question: nil)
                let viewModel = QuestionsGridQuestionEditorViewModel()
                let view = QuestionsGridQuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: true,
                    rootView: QuestionsGridQuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            container.register(QuestionsGridQuestionEditorViewController.self) { (resolver: Resolver, topic: QuestionsGridTopicModel, question: QuestionsGridQuestionModel) in
                let interactor = QuestionsGridQuestionEditorInteractor(topic: topic, question: question)
                let viewModel = QuestionsGridQuestionEditorViewModel(
                    questionText: question.text,
                    questionAnswer: question.answer,
                    questionPrice: question.price
                )
                let view = QuestionsGridQuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: false,
                    rootView: QuestionsGridQuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
        }
    }
}
