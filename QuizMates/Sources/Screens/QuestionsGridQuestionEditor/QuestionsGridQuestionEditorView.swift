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
    @State private var isEditingQuestionText: Bool = false
    @State private var isEditingQuestionAnswer: Bool = false
    @FocusState private var isFocusedQuestionText: Bool
    @FocusState private var isFocusedQuestionAnswer: Bool
    weak var delegate: QuestionsGridQuestionEditorViewDelegate?

    private let priceValues = Array(stride(from: 50, through: 2000, by: 50))

    var body: some View {
        ScrollView(.vertical) {
            questionTextView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            questionAnswerView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            questionPriceView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            toggleQuestionTextEditing(isOn: true)
        }
    }

    private var questionTextView: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("Текст вопроса", text: $viewModel.questionText)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(.plain)
                .focused($isFocusedQuestionText)
                .submitLabel(.done)
                .onSubmit {
                    toggleQuestionTextEditing(isOn: false)
                }
            Spacer()
        }
    }

    private var questionAnswerView: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("Ответ на вопрос", text: $viewModel.questionAnswer)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(.plain)
                .focused($isFocusedQuestionAnswer)
                .submitLabel(.done)
                .onSubmit {
                    toggleQuestionAnswerEditing(isOn: false)
                }
            Spacer()
        }
    }

    private var questionPriceView: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Стоимость вопроса")
                .font(.title2)
                .fontWeight(.bold)
            Picker("Стоимость вопроса", selection: $viewModel.questionPrice) {
                ForEach(priceValues, id: \.self) { number in
                    Text("\(number)")
                }
            }
            Spacer()
        }
    }

    private func toggleQuestionTextEditing(isOn: Bool) {
        if isOn {
            withAnimation(.spring()) {
                isEditingQuestionText = true
                isFocusedQuestionText = true
            }
        } else {
            withAnimation(.spring()) {
                isEditingQuestionText = false
                isFocusedQuestionText = false
            }
        }
    }

    private func toggleQuestionAnswerEditing(isOn: Bool) {
        if isOn {
            withAnimation(.spring()) {
                isEditingQuestionAnswer = true
                isFocusedQuestionAnswer = true
            }
        } else {
            withAnimation(.spring()) {
                isEditingQuestionAnswer = false
                isFocusedQuestionAnswer = false
            }
        }
    }
}
