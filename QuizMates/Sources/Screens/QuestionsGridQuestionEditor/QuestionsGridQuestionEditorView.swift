//
//  QuestionsGridQuestionEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import PhotosUI
import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorViewDelegate: AnyObject {
    func didPickPhoto(photo: PhotosPickerItem)
}

struct QuestionsGridQuestionEditorView: View {
    @Bindable var viewModel: QuestionsGridQuestionEditorViewModel
    @State private var isEditingQuestionText: Bool = false
    @State private var isEditingQuestionAnswer: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @FocusState private var isFocusedQuestionText: Bool
    @FocusState private var isFocusedQuestionAnswer: Bool
    weak var delegate: QuestionsGridQuestionEditorViewDelegate?

    private let priceValues = Array(stride(from: 50, through: 2000, by: 50))

    var body: some View {
        ScrollView(.vertical) {
            photosView
                .padding(top: 16, leading: 0, bottom: 0, trailing: 0)
            photoPickerView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
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
    }

    private var photosView: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 8) {
                ForEach(viewModel.medias) { media in
                    QuestionsGridQuestionEditorThumbnailView(
                        fileName: media.fileName,
                        fileExtension: media.fileExtension,
                        size: CGSize(width: 100, height: 100),
                        delegate: delegate
                    )
                }
                ForEach(viewModel.mediaDrafts) { mediaDraft in
                    QuestionsGridQuestionEditorThumbnailView(
                        fileName: mediaDraft.fileName,
                        fileExtension: mediaDraft.fileExtension,
                        size: CGSize(width: 100, height: 100),
                        delegate: delegate
                    )
                }
            }
            .padding(leading: 16, trailing: 16)
        }
        .scrollIndicators(.never)
    }

    private var photoPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Добавить фото", systemImage: "plus.circle.fill")
                    .font(.title2)
            }
            .onChange(of: selectedItem) { _, newItem in
                if let newItem {
                    delegate?.didPickPhoto(photo: newItem)
                }
            }
            Spacer(minLength: 0)
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

private struct QuestionsGridQuestionEditorThumbnailView: View {
    let fileName: String
    let fileExtension: String
    let size: CGSize

    weak var delegate: QuestionsGridQuestionEditorViewDelegate?

    var body: some View {
        if let image = loadImage() {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            ProgressView()
        }
    }

    @MainActor
    private func loadImage() -> UIImage? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mediaFolder = directory.appendingPathComponent("Media", isDirectory: true)
        let path = mediaFolder.appending(path: "\(fileName).\(fileExtension)").path()
        return UIImage(contentsOfFile: path)
    }
}
