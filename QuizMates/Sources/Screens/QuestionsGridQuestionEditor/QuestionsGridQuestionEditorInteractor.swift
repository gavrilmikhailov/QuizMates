//
//  QuestionsGridQuestionEditorInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import PhotosUI
import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorInteractorProtocol {
    func loadQuestionContent(isInitial: Bool)
    func updateQuestionContent(text: String, answer: String, price: Int)
    func addMediaItems(items: [PhotosPickerItem])
    func addMediaItems(audios: [URL])
    func deleteMedia(fileName: String)
    func submitQuestion(text: String, answer: String, price: Int)
    func deleteQuestion()
}

@MainActor
final class QuestionsGridQuestionEditorInteractor: QuestionsGridQuestionEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridQuestionEditorViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let topic: QuestionsGridTopicDTO
    private let mode: QuestionsGridQuestionEditorMode
    private var medias: [QuestionsGridMediaDTO] = []
    private var mediaDrafts: [QuestionsGridMediaDraft] = []

    // MARK: - Initializer

    init(
        databaseService: DatabaseService,
        topic: QuestionsGridTopicDTO,
        mode: QuestionsGridQuestionEditorMode
    ) {
        self.databaseService = databaseService
        self.topic = topic
        self.mode = mode
    }

    // MARK: - QuestionsGridQuestionEditorInteractorProtocol

    func loadQuestionContent(isInitial: Bool) {
        switch mode {
        case .createNewQuestion(let draft):
            medias = []
            mediaDrafts = []
            view?.displayQuestionContent(
                isInitial: isInitial,
                medias: medias,
                mediaDrafts: mediaDrafts,
                text: draft.text,
                answer: draft.answer,
                price: draft.price
            )
        case .editExistingQuestion(let dto):
            Task {
                do {
                    medias = try await databaseService.readMedias(ids: dto.medias)
                    mediaDrafts = []
                    await MainActor.run {
                        view?.displayQuestionContent(
                            isInitial: isInitial,
                            medias: medias,
                            mediaDrafts: mediaDrafts,
                            text: dto.text,
                            answer: dto.answer,
                            price: dto.price
                        )
                    }
                } catch {
                    await MainActor.run {
                        view?.displayError(text: error.localizedDescription)
                    }
                }
            }
        }
    }

    func updateQuestionContent(text: String, answer: String, price: Int) {
        view?.displayQuestionContent(
            isInitial: false,
            medias: medias,
            mediaDrafts: mediaDrafts,
            text: text,
            answer: answer,
            price: price
        )
    }

    func addMediaItems(items: [PhotosPickerItem]) {
        Task(priority: .userInitiated) {
            for item in items {
                do {
                    let isVideo = item.supportedContentTypes.contains { $0.conforms(to: .movie) }
                    if isVideo {
                        guard let data = try await item.loadTransferable(type: Data.self) else {
                            continue
                        }
                        guard let fileExtension = item.supportedContentTypes.first?.preferredFilenameExtension else {
                            continue
                        }
                        guard let thumbnailData = QuizMatesAsset.videoPlaceholder.image.jpegData(compressionQuality: 1) else {
                            continue
                        }
                        print("Did pick video with file extension: \(fileExtension)")
                        let draft = QuestionsGridMediaDraft(
                            id: UUID(),
                            fileName: UUID().uuidString,
                            fileExtension: fileExtension,
                            type: "video",
                            data: data,
                            thumbnailData: thumbnailData,
                            createdAt: .now
                        )
                        await MainActor.run {
                            self.mediaDrafts.append(draft)
                            self.view?.displayUpdateContent()
                        }
                    } else {
                        guard let data = try await item.loadTransferable(type: Data.self) else {
                            continue
                        }
                        guard let fileExtension = item.supportedContentTypes.first?.preferredFilenameExtension else {
                            continue
                        }
                        print("Did pick photo with file extension: \(fileExtension)")
                        let draft = QuestionsGridMediaDraft(
                            id: UUID(),
                            fileName: UUID().uuidString,
                            fileExtension: fileExtension,
                            type: "photo",
                            data: data,
                            thumbnailData: UIImage(data: data)?.jpegThumbnailData() ?? Data(),
                            createdAt: .now
                        )
                        await MainActor.run {
                            self.mediaDrafts.append(draft)
                            self.view?.displayUpdateContent()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    continue
                }
            }
        }
    }

    func addMediaItems(audios: [URL]) {
        Task {
            for url in audios {
                guard url.startAccessingSecurityScopedResource() else {
                    continue
                }
                guard let thumbnailData = QuizMatesAsset.audioPlaceholder.image.jpegData(compressionQuality: 1) else {
                    continue
                }
                do {
                    let draft = QuestionsGridMediaDraft(
                        id: UUID(),
                        fileName: UUID().uuidString,
                        fileExtension: url.pathExtension,
                        type: "audio",
                        data: try Data(contentsOf: url),
                        thumbnailData: thumbnailData,
                        createdAt: .now
                    )
                    await MainActor.run {
                        self.mediaDrafts.append(draft)
                        self.view?.displayUpdateContent()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                url.stopAccessingSecurityScopedResource()
            }
        }
    }

    func deleteMedia(fileName: String) {
        medias.removeAll { $0.fileName == fileName }
        mediaDrafts.removeAll { $0.fileName == fileName }
        view?.displayUpdateContent()
    }

    func submitQuestion(text: String, answer: String, price: Int) {
        switch mode {
        case .createNewQuestion(let draft):
            let newDraft = QuestionsGridQuestionDraft(
                text: text,
                answer: answer,
                price: price,
                isAnswered: draft.isAnswered
            )
            view?.displaySubmitNewQuestion(question: newDraft, medias: mediaDrafts, topic: topic)
        case .editExistingQuestion(let dto):
            let newDTO = QuestionsGridQuestionDTO(
                id: dto.id,
                medias: medias.map { $0.id },
                text: text,
                answer: answer,
                price: price,
                isAnswered: dto.isAnswered
            )
            view?.displaySubmitUpdatedQuestion(question: newDTO, medias: mediaDrafts)
        }
    }

    func deleteQuestion() {
        switch mode {
        case .createNewQuestion:
            break
        case .editExistingQuestion(let dto):
            view?.displayDeleteQuestion(question: dto)
        }
    }
}
