//
//  QuestionsGridQuestionEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorViewControllerProtocol: AnyObject {
}

final class QuestionsGridQuestionEditorViewController: UIHostingController<QuestionsGridQuestionEditorView> {

    // MARK: - Private properties

    private let interactor: QuestionsGridQuestionEditorInteractorProtocol
    private let viewModel: QuestionsGridQuestionEditorViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridQuestionEditorInteractorProtocol,
        viewModel: QuestionsGridQuestionEditorViewModel,
        rootView: QuestionsGridQuestionEditorView
    ) {
        self.interactor = interactor
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - QuestionsGridQuestionEditorViewControllerProtocol

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewControllerProtocol {
}

// MARK: - QuestionsGridQuestionEditorViewDelegate

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewDelegate {
}
