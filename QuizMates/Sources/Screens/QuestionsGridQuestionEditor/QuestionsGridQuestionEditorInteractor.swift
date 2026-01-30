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
    func deleteMedia(dto: QuestionsGridMediaDTO)
    func deleteMediaDraft(draft: QuestionsGridMediaDraft)
    func submitQuestion(text: String, answer: String, price: Int)
    func deleteQuestion()
}

@MainActor
final class QuestionsGridQuestionEditorInteractor: QuestionsGridQuestionEditorInteractorProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridQuestionEditorViewControllerProtocol?

    // MARK: - Private properties

    private let databaseService: DatabaseService
    private let mediaStorageService: MediaStorageService
    private let topic: QuestionsGridTopicDTO
    private let mode: QuestionsGridQuestionEditorMode
    private var medias: [QuestionsGridMediaDTO] = []
    private var mediaDrafts: [QuestionsGridMediaDraft] = []

    // MARK: - Initializer

    init(
        databaseService: DatabaseService,
        mediaStorageService: MediaStorageService,
        topic: QuestionsGridTopicDTO,
        mode: QuestionsGridQuestionEditorMode
    ) {
        self.databaseService = databaseService
        self.mediaStorageService = mediaStorageService
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
        Task {
            for item in items {
                do {
                    guard let data = try await item.loadTransferable(type: Data.self) else {
                        continue
                    }
                    guard let fileExtension = item.supportedContentTypes.first?.preferredFilenameExtension else {
                        continue
                    }
                    let isVideo = item.supportedContentTypes.contains { $0.conforms(to: .movie) }
                    print("Did pick media with file extension: \(fileExtension)")
                    let draft = QuestionsGridMediaDraft(
                        id: UUID(),
                        fileName: UUID().uuidString,
                        fileExtension: fileExtension,
                        isVideo: isVideo,
                        createdAt: .now
                    )
                    try await mediaStorageService.saveImage(data: data, for: draft)
                    mediaDrafts.append(draft)
                } catch {
                    print(error.localizedDescription)
                }
            }
            await MainActor.run {
                view?.displayUpdateContent()
            }
        }
    }

    func deleteMedia(dto: QuestionsGridMediaDTO) {
        medias.removeAll { $0.id == dto.id }
        view?.displayUpdateContent()
    }

    func deleteMediaDraft(draft: QuestionsGridMediaDraft) {
        mediaDrafts.removeAll { $0.id == draft.id }
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
