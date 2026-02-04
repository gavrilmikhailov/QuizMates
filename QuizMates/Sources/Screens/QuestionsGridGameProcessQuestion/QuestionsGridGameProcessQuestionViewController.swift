//
//  QuestionsGridGameProcessQuestionViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessQuestionViewControllerProtocol: AnyObject {
}

final class QuestionsGridGameProcessQuestionViewController: UIHostingController<QuestionsGridGameProcessQuestionView> {

    // MARK: - Private properties

    private let interactor: QuestionsGridGameProcessQuestionInteractorProtocol
    private let viewModel: QuestionsGridGameProcessQuestionViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameProcessQuestionInteractorProtocol,
        viewModel: QuestionsGridGameProcessQuestionViewModel,
        rootView: QuestionsGridGameProcessQuestionView
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

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - QuestionsGridGameProcessQuestionViewControllerProtocol

extension QuestionsGridGameProcessQuestionViewController: QuestionsGridGameProcessQuestionViewControllerProtocol {
}

// MARK: - QuestionsGridGameProcessQuestionViewDelegate

extension QuestionsGridGameProcessQuestionViewController: QuestionsGridGameProcessQuestionViewDelegate {
}
