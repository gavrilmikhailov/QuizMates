//
//  QuestionsGridPhotoPreviewViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 29.01.2026.
//

import SwiftUI

final class QuestionsGridPhotoPreviewViewController: UIHostingController<QuestionsGridPhotoPreviewView> {

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

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }
}
