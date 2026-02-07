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

    @FocusState private var isPlayerNameFocused: Bool

    var body: some View {
        ScrollView(.vertical) {
            playerEmojiView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            playerNameView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                isPlayerNameFocused = false
            }
        }
    }

    private var playerEmojiView: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Эмодзи игрока")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.placeholderText))
                EmojiTextField(text: $viewModel.emoji, placeholder: "")
                    .frame(width: 50, height: 50)
                    .padding()
                    .background {
                        Color.gray.opacity(0.1)
                    }
                    .cornerRadius(10)
            }
            Spacer()
        }
    }

    private var playerNameView: some View {
        HStack(alignment: .center, spacing: 12) {
            TextField("Имя игрока", text: $viewModel.name)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(.plain)
                .focused($isPlayerNameFocused)
                .submitLabel(.done)
                .onSubmit {
                    withAnimation(.spring()) {
                        isPlayerNameFocused = false
                    }
                }
            Spacer()
        }
    }
}
