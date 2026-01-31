//
//  QuestionsGridPlayerEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

final class QuestionsGridPlayerEditorViewController: UIHostingController<QuestionsGridPlayerEditorView> {

    // MARK: - Private properties

    private let viewModel: QuestionsGridPlayerEditorViewModel
    private let mode: QuestionsGridPlayerEditorMode

    // MARK: - Initializer

    init(
        viewModel: QuestionsGridPlayerEditorViewModel,
        mode: QuestionsGridPlayerEditorMode,
        rootView: QuestionsGridPlayerEditorView
    ) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - QuestionsGridPlayerEditorViewDelegate

extension QuestionsGridPlayerEditorViewController: QuestionsGridPlayerEditorViewDelegate {
}
