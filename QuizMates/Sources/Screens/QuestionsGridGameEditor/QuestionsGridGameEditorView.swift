//
//  QuestionsGridGameEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import SwiftUI

@MainActor
protocol QuestionsGridGameEditorViewDelegate: AnyObject {
    func didSumbitNewGameName(name: String)
}

struct QuestionsGridGameEditorView: View {

    @Bindable var viewModel: QuestionsGridGameEditorViewModel
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    weak var delegate: QuestionsGridGameEditorViewDelegate?

    var body: some View {
        ScrollView(.vertical) {
            HStack(alignment: .center, spacing: 12) {
                if isEditing {
                    TextField("Название игры", text: $viewModel.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .textFieldStyle(.plain)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            withAnimation(.spring()) {
                                isEditing = false
                            }
                            delegate?.didSumbitNewGameName(name: viewModel.name)
                        }
                } else {
                    Text(viewModel.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                if !isEditing {
                    Button(
                        action: {
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
                        }, label: {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.small)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(UIColor.label))
                        }
                    )
                }
                Spacer()
            }
            .padding(top: 16, leading: 16, bottom: 0, trailing: 16)

            Text("TODO: Grid of questions")
                .padding(top: 40)
        }
    }
}
