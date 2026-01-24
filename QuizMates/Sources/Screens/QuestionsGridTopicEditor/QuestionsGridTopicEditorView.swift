//
//  QuestionsGridTopicEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridTopicEditorViewDelegate: AnyObject {
    func didSubmitNewTopicName()
}

struct QuestionsGridTopicEditorView: View {
    @Bindable var viewModel: QuestionsGridTopicEditorViewModel
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    weak var delegate: QuestionsGridTopicEditorViewDelegate?

    var body: some View {
        ScrollView(.vertical) {
            topicNameView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleNameEditing(isOn: false, isFinal: false)
        }
        .onAppear {
            toggleNameEditing(isOn: true, isFinal: false)
        }
    }

    private var topicNameView: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("Название темы", text: $viewModel.name)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit {
                    toggleNameEditing(isOn: false, isFinal: true)
                }
            Spacer()
        }
    }

    private func toggleNameEditing(isOn: Bool, isFinal: Bool) {
        if isOn {
            withAnimation(.spring()) {
                isEditing = true
                isFocused = true
            }
            Task {
                try? await Task.sleep(for: .milliseconds(50))
                UIApplication.shared.sendAction(
                    #selector(UIResponder.selectAll(_:)),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        } else {
            withAnimation(.spring()) {
                isEditing = false
                isFocused = false
            }
            if isFinal {
                delegate?.didSubmitNewTopicName()
            }
        }
    }
}
