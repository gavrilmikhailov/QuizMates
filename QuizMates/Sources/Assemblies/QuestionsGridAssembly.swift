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
                let interactor = QuestionsGridGameEditorInteractor(presenter: presenter, context: context)
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
        }
    }
}
