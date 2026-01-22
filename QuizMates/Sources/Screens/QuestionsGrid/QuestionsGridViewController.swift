//
//  QuestionsGridViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftUI

protocol QuestionsGridViewControllerProtocol: AnyObject {
}

final class QuestionsGridViewController: UIHostingController<QuestionsGridView> {

    // MARK: - Private properties

    private let interactor: QuestionsGridInteractorProtocol
    private let viewModel: QuestionsGridViewModel

    // MARK: - Initializer

    init(interactor: QuestionsGridInteractorProtocol, viewModel: QuestionsGridViewModel, rootView: QuestionsGridView) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = "Questions Grid"
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }

    @objc
    private func addButtonTapped() {
    }
}

// MARK: - QuestionsGridViewControllerProtocol

extension QuestionsGridViewController: QuestionsGridViewControllerProtocol {
}

// MARK: - QuestionsGridViewDelegate

extension QuestionsGridViewController: QuestionsGridViewDelegate {
}
