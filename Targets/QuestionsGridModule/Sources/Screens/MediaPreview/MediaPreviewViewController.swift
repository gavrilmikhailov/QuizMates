//
//  MediaPreviewViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 29.01.2026.
//

import SwiftUI

@MainActor
protocol MediaPreviewDelegate: AnyObject {
    func didDeleteMedia(fileName: String)
}

final class MediaPreviewViewController: UIHostingController<MediaPreviewView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    weak var delegate: MediaPreviewDelegate?

    // MARK: - Private properties

    private let fileName: String

    // MARK: - Initializer

    init(fileName: String, rootView: MediaPreviewView) {
        self.fileName = fileName
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
        title = ""
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: Strings.deleteMediaTitle,
            message: Strings.deleteMediaWarning,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: Strings.deleteMediaAction, style: .destructive) { [unowned self] _ in
            self.delegate?.didDeleteMedia(fileName: self.fileName)
            self.onClose?()
        }
        let cancelAction = UIAlertAction(title: Strings.deleteMediaCancel, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}
