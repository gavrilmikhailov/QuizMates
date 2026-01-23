//
//  QuestionsGridGameEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

protocol QuestionsGridGameEditorViewControllerProtocol: AnyObject {
}

final class QuestionsGridGameEditorViewController: UIHostingController<QuestionsGridGameEditorView> {

    // MARK: - Private properties

    private let interactor: QuestionsGridGameEditorInteractorProtocol
    private let viewModel: QuestionsGridGameEditorViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameEditorInteractorProtocol,
        viewModel: QuestionsGridGameEditorViewModel,
        rootView: QuestionsGridGameEditorView
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
        interactor.createNewGameIfNeeded()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = ""
    }
}

// MARK: - QuestionsGridGameEditorViewControllerProtocol

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewControllerProtocol {
}

// MARK: - QuestionsGridGameEditorViewDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewDelegate {
}
