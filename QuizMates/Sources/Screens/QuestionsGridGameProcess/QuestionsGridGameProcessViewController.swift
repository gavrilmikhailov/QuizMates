//
//  QuestionsGridGameProcessViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessViewControllerProtocol: AnyObject {
    func displayGameContent(title: String)
}

final class QuestionsGridGameProcessViewController: UIHostingController<QuestionsGridGameProcessView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?

    // MARK: - Private properties

    private let interactor: QuestionsGridGameProcessInteractorProtocol
    private let viewModel: QuestionsGridGameProcessViewModel

    // MARK: - Initializer

    init(
        interactor: QuestionsGridGameProcessInteractorProtocol,
        viewModel: QuestionsGridGameProcessViewModel,
        rootView: QuestionsGridGameProcessView
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
        interactor.loadGameContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }
}

// MARK: - QuestionsGridGameProcessViewControllerProtocol

extension QuestionsGridGameProcessViewController: QuestionsGridGameProcessViewControllerProtocol {

    func displayGameContent(title: String) {
        self.title = title
    }
}

// MARK: - QuestionsGridGameProcessViewDelegate

extension QuestionsGridGameProcessViewController: QuestionsGridGameProcessViewDelegate {
}
