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
    func didPickMediaItems(items: [PhotosPickerItem])
    func didPickMediaItems(audios: [URL])
    func didTapMedia(media: QuestionsGridMediaDTO)
    func didTapMedia(draft: QuestionsGridMediaDraft)
    func didDeleteMedia(dto: QuestionsGridMediaDTO)
    func didDeleteMediaDraft(draft: QuestionsGridMediaDraft)
}

struct QuestionsGridQuestionEditorView: View {
    @Bindable var viewModel: QuestionsGridQuestionEditorViewModel

    @State private var isEditingQuestionText: Bool = false
    @State private var isEditingQuestionAnswer: Bool = false

    @FocusState private var isFocusedQuestionText: Bool
    @FocusState private var isFocusedQuestionAnswer: Bool

    @State private var isFileImporterPresented = false

    weak var delegate: QuestionsGridQuestionEditorViewDelegate?

    private let priceValues = Array(stride(from: 50, through: 2000, by: 50))

    var body: some View {
        ScrollView(.vertical) {
            photosView
                .padding(top: 16, leading: 0, bottom: 0, trailing: 0)
            photoPickerView
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
                ForEach(Array(viewModel.medias.enumerated()), id: \.element.id) { index, element in
                    QuestionsGridQuestionEditorThumbnailView(
                        url: element.localURL,
                        type: element.type,
                        size: CGSize(width: 100, height: 100),
                        onSelect: {
                            delegate?.didTapMedia(media: element)
                        },
                        onDelete: {
                            delegate?.didDeleteMedia(dto: element)
                        }
                    )
                }
                ForEach(Array(viewModel.mediaDrafts.enumerated()), id: \.element.id) { index, element in
                    QuestionsGridQuestionEditorThumbnailView(
                        url: element.localURL,
                        type: element.type,
                        size: CGSize(width: 100, height: 100),
                        onSelect: {
                            delegate?.didTapMedia(draft: element)
                        },
                        onDelete: {
                            delegate?.didDeleteMediaDraft(draft: element)
                        }
                    )
                }
            }
            .padding(leading: 16, trailing: 16)
        }
        .scrollIndicators(.never)
    }

    private var photoPickerView: some View {
        HStack(alignment: .center, spacing: 0) {
            PhotosPicker(
                selection: $viewModel.photoPickerItems,
                selectionBehavior: .ordered,
                matching: .any(of: [.images, .videos])
            ) {
                Label("Добавить фото или видео", systemImage: "plus.circle.fill")
                    .font(.title3)
            }
            .onChange(of: viewModel.photoPickerItems) { _, items in
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
                    Label("Добавить аудио", systemImage: "plus.circle.fill")
                        .font(.title3)
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

private struct QuestionsGridQuestionEditorThumbnailView: View {
    let url: URL
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
                switch type {
                case "photo":
                    AsyncImage(
                        url: url,
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        },
                        placeholder: {
                            Color.clear
                                .frame(width: size.width, height: size.height)
                                .overlay {
                                    ProgressView()
                                }
                        }
                    )
                case "video":
                    if let videoThumbnail {
                        Image(uiImage: videoThumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                Image(systemName: "video")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                    } else {
                        Color.clear
                            .frame(width: size.width, height: size.height)
                            .overlay {
                                ProgressView()
                            }
                    }
                case "audio":
                    if let audioThumbnail {
                        Image(uiImage: audioThumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        Color.clear
                            .frame(width: size.width, height: size.height)
                            .overlay {
                                ProgressView()
                            }
                    }
                default:
                    Color.clear
                        .frame(width: size.width, height: size.height)
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
        .onAppear {
            switch type {
            case "video":
                Task {
                    videoThumbnail = await generateVideoThumbnail(for: url)
                }
            case "audio":
                Task {
                    audioThumbnail = generateAudioThumbnail()
                }
            default:
                break
            }
        }
    }

    private func generateVideoThumbnail(for url: URL) async -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)

        generator.appliesPreferredTrackTransform = true

        do {
            let time = CMTime(seconds: 1, preferredTimescale: 600)
            let cgImage = try await generator.image(at: time).image
            return UIImage(cgImage: cgImage)
        } catch {
            print("Couldn't generate video thumbnail: \(error)")
            return UIImage(systemName: "video.slash")
        }
    }

    private func generateAudioThumbnail() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        return renderer.image { ctx in
            UIColor.systemGray6.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            let icon = UIImage(systemName: "music.mic")?.withTintColor(.systemPurple)
            icon?.draw(in: CGRect(x: 25, y: 25, width: 50, height: 50))
        }
    }
}
