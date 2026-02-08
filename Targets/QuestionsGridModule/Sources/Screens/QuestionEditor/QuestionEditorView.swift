//
//  QuestionEditorView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import PhotosUI
import SwiftUI

@MainActor
protocol QuestionEditorViewDelegate: AnyObject {
    func didPickMediaItems(items: [PhotosPickerItem])
    func didPickMediaItems(images: [URL])
    func didPickMediaItems(audios: [URL])
    func didTapMedia(media: MediaDTO)
    func didTapMedia(draft: MediaDraft)
    func didTapDeleteMedia(fileName: String)
}

struct QuestionEditorView: View {
    @Bindable var viewModel: QuestionEditorViewModel

    @State private var isEditingQuestionText: Bool = false
    @State private var isEditingQuestionAnswer: Bool = false

    @FocusState private var isFocusedQuestionText: Bool
    @FocusState private var isFocusedQuestionAnswer: Bool

    @State private var isFileImporterPresented = false

    weak var delegate: QuestionEditorViewDelegate?

    private let priceValues = Array(stride(from: 100, through: 1200, by: 100))

    var body: some View {
        ScrollView(.vertical) {
            photosView
                .padding(top: 16, leading: 0, bottom: 0, trailing: 0)
            photoFromGalleryPickerView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            photoFromFilesPickerView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            videoPickerView
                .padding(top: 16, leading: 16, bottom: 0, trailing: 16)
            audioPickerView
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
                ForEach(viewModel.medias) { element in
                    QuestionEditorThumbnailView(
                        data: element.thumbnailData,
                        type: element.type,
                        size: CGSize(width: 100, height: 100),
                        onSelect: {
                            delegate?.didTapMedia(media: element)
                        },
                        onDelete: {
                            delegate?.didTapDeleteMedia(fileName: element.fileName)
                        }
                    )
                }
                ForEach(viewModel.mediaDrafts) { element in
                    QuestionEditorThumbnailView(
                        data: element.thumbnailData,
                        type: element.type,
                        size: CGSize(width: 100, height: 100),
                        onSelect: {
                            delegate?.didTapMedia(draft: element)
                        },
                        onDelete: {
                            delegate?.didTapDeleteMedia(fileName: element.fileName)
                        }
                    )
                }
            }
            .padding(leading: 16, trailing: 16)
        }
        .scrollIndicators(.never)
    }

    private var photoFromGalleryPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            PhotosPicker(
                selection: $viewModel.photoPickerItems,
                selectionBehavior: .ordered,
                matching: .any(of: [.images])
            ) {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "photo.badge.plus")
                    Text("Добавить фото из галереи")
                        .font(.title3)
                }
            }
            .onChange(of: viewModel.photoPickerItems) { _, items in
                delegate?.didPickMediaItems(items: items)
            }
            Spacer(minLength: 0)
        }
    }

    private var photoFromFilesPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(
                action: {
                    isFileImporterPresented = true
                },
                label: {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "photo.badge.plus")
                        Text("Добавить фото из файлов")
                            .font(.title3)
                    }
                }
            )
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [.image],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    delegate?.didPickMediaItems(images: urls)
                }
            }
            Spacer(minLength: 0)
        }
    }

    private var videoPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            PhotosPicker(
                selection: $viewModel.videoPickerItems,
                selectionBehavior: .ordered,
                matching: .any(of: [.videos])
            ) {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "video.badge.plus")
                    Text("Добавить видео")
                        .font(.title3)
                }
            }
            .onChange(of: viewModel.videoPickerItems) { _, items in
                delegate?.didPickMediaItems(items: items)
            }
            Spacer(minLength: 0)
        }
    }

    private var audioPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(
                action: {
                    isFileImporterPresented = true
                },
                label: {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "microphone.badge.plus")
                        Text("Добавить аудио")
                            .font(.title3)
                    }
                }
            )
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [.audio],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    delegate?.didPickMediaItems(audios: urls)
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

private struct QuestionEditorThumbnailView: View {
    let data: Data?
    let type: String
    let size: CGSize
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var videoThumbnail: UIImage?
    @State private var audioThumbnail: UIImage?

    var body: some View {
        Button(
            action: onSelect,
            label: {
                if let data, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Color.clear
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            Image(systemName: "questionmark.circle.fill")
                        }
                }
            }
        )
        .buttonStyle(.plain)
        .contextMenu {
            Button(
                role: .destructive,
                action: onDelete,
                label: {
                    Label("Удалить", systemImage: "trash")
                }
            )
        }
    }
}
