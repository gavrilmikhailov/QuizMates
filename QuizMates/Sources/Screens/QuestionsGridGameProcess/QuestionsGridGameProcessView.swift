//
//  QuestionsGridGameProcessView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameProcessViewDelegate: AnyObject {
}

struct QuestionsGridGameProcessView: View {
    @Bindable var viewModel: QuestionsGridGameProcessViewModel
    weak var delegate: QuestionsGridGameProcessViewDelegate?

    var body: some View {
        EmptyView()
    }
}
