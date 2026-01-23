//
//  QuestionsGridGameEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameEditorViewControllerProtocol: AnyObject {
    func displayGameName(name: String)
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
        interactor.loadGameName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - QuestionsGridGameEditorViewControllerProtocol

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewControllerProtocol {

    func displayGameName(name: String) {
        viewModel.name = name
    }
}

// MARK: - QuestionsGridGameEditorViewDelegate

extension QuestionsGridGameEditorViewController: QuestionsGridGameEditorViewDelegate {

    func didSumbitNewGameName(name: String) {
        interactor.updateGameName(name: name)
    }
}
