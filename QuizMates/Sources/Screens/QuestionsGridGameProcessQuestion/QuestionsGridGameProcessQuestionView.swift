//
//  QuestionsGridGameProcessQuestionView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessQuestionViewDelegate: AnyObject {
}

struct QuestionsGridGameProcessQuestionView: View {
    @Bindable var viewModel: QuestionsGridGameProcessQuestionViewModel
    weak var delegate: QuestionsGridGameProcessQuestionViewDelegate?

    var body: some View {
        EmptyView()
    }
}
