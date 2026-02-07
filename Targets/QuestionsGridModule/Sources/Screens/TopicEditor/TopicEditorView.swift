//
//  TopicEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import CoreModule
import SwiftUI

@MainActor
protocol TopicEditorViewDelegate: AnyObject {
}

struct TopicEditorView: View {
    @Bindable var viewModel: TopicEditorViewModel
    @FocusState private var isFocused: Bool
    weak var delegate: TopicEditorViewDelegate?

    var body: some View {
        ScrollView(.vertical) {
            topicNameView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleNameEditing(isOn: false)
        }
        .onAppear {
            toggleNameEditing(isOn: true)
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
                    toggleNameEditing(isOn: false)
                }
            Spacer()
        }
    }

    private func toggleNameEditing(isOn: Bool) {
        if isOn {
            withAnimation(.spring()) {
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
                isFocused = false
            }
        }
    }
}
