//
//  QuestionsGridPhotoPreviewViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 29.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridPhotoPreviewDelegate: AnyObject {
    func didDeletePhoto(mode: QuestionsGridPhotoPreviewMode)
}

final class QuestionsGridPhotoPreviewViewController: UIHostingController<QuestionsGridPhotoPreviewView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: QuestionsGridPhotoPreviewDelegate?

    // MARK: - Private properties

    private let mode: QuestionsGridPhotoPreviewMode

    // MARK: - Initializer

    init(mode: QuestionsGridPhotoPreviewMode, rootView: QuestionsGridPhotoPreviewView) {
        self.mode = mode
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
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        navigationItem.rightBarButtonItem = deleteButton
        title = "Новый вопрос"
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить это изображение?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [unowned self] _ in
            self.delegate?.didDeletePhoto(mode: self.mode)
            self.onClose?()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}
