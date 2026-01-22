//
//  QuestionsGridView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftUI

protocol QuestionsGridViewDelegate: AnyObject {
}

struct QuestionsGridView: View {

    @Bindable var viewModel: QuestionsGridViewModel

    weak var delegate: QuestionsGridViewDelegate?

    var body: some View {
        List {
            Text("Элемент списка игр")
        }
        .listStyle(.inset)
    }
}
