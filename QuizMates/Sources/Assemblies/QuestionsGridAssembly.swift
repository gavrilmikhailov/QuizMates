//
//  QuestionsGridAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData
import Swinject

final class QuestionsGridAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Swinject.Container) {
        container.register(QuestionsGridViewController.self) { resolver in
            let context = resolver.resolve(ModelContext.self)!
            let presenter = QuestionsGridPresenter()
            let interactor = QuestionsGridInteractor(presenter: presenter, context: context)
            let viewModel = QuestionsGridViewModel()
            let view = QuestionsGridViewController(
                interactor: interactor,
                viewModel: viewModel,
                rootView: QuestionsGridView(viewModel: viewModel)
            )
            view.rootView.delegate = view
            presenter.view = view
            return view
        }
    }
}
