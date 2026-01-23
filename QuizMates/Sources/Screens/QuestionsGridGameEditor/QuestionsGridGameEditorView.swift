//
//  QuestionsGridGameEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

protocol QuestionsGridGameEditorViewDelegate: AnyObject {
}

struct QuestionsGridGameEditorView: View {

    @Bindable var viewModel: QuestionsGridGameEditorViewModel

    weak var delegate: QuestionsGridGameEditorViewDelegate?

    var body: some View {
        EmptyView()
    }
}
