//
//  QuestionsGridQuestionEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorViewDelegate: AnyObject {
}

struct QuestionsGridQuestionEditorView: View {
    @Bindable var viewModel: QuestionsGridQuestionEditorViewModel
    weak var delegate: QuestionsGridQuestionEditorViewDelegate?

    var body: some View {
        EmptyView()
    }
}
