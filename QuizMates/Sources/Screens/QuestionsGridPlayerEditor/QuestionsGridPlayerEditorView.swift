//
//  QuestionsGridPlayerEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftUI

protocol QuestionsGridPlayerEditorViewDelegate: AnyObject {
}

struct QuestionsGridPlayerEditorView: View {
    @Bindable var viewModel: QuestionsGridPlayerEditorViewModel
    weak var delegate: QuestionsGridPlayerEditorViewDelegate?

    var body: some View {
        EmptyView()
    }
}
