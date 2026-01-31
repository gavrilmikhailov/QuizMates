//
//  DatabaseService.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

protocol DatabaseService: Actor {
    func readGames() async throws -> [QuestionsGridGameDTO]
    func readGame(id: PersistentIdentifier) async throws -> QuestionsGridGameDTO
    func createGame(draft: QuestionsGridGameDraft) async throws -> QuestionsGridGameDTO
    func updateGame(dto: QuestionsGridGameDTO) async throws
    func deleteGame(id: PersistentIdentifier) async throws

    func createTopic(draft: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) async throws -> QuestionsGridTopicDTO
    func readTopic(id: PersistentIdentifier) async throws -> QuestionsGridTopicDTO
    func readTopics(ids: [PersistentIdentifier]) async throws -> [QuestionsGridTopicDTO]
    func updateTopic(dto: QuestionsGridTopicDTO) async throws
    func deleteTopic(dto: QuestionsGridTopicDTO) async throws

    func createQuestion(
        draft: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    ) async throws -> QuestionsGridQuestionDTO
    func readQuestions(ids: [PersistentIdentifier]) async throws -> [QuestionsGridQuestionDTO]
    func readQuestion(id: PersistentIdentifier) async throws -> QuestionsGridQuestionDTO
    func updateQuestion(dto: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft]) async throws
    func deleteQuestion(dto: QuestionsGridQuestionDTO) async throws

    func createMedia(
        draft: QuestionsGridMediaDraft,
        question: QuestionsGridQuestionDTO
    ) async throws -> QuestionsGridMediaDTO
    func readMedias() async throws -> [QuestionsGridMediaDTO]
    func readMedias(ids: [PersistentIdentifier]) async throws -> [QuestionsGridMediaDTO]

    func createPlayer(
        draft: QuestionsGridPlayerDraft,
        game: QuestionsGridGameDTO
    ) async throws -> QuestionsGridPlayerDTO
    func readPlayers(ids: [PersistentIdentifier]) async throws -> [QuestionsGridPlayerDTO]
    func updatePlayer(dto: QuestionsGridPlayerDTO) async throws
    func deletePlayer(dto: QuestionsGridPlayerDTO) async throws
}

actor DatabaseActor: DatabaseService {

    // MARK: - Private properties

    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    // MARK: - Initializer

    init(container: ModelContainer) {
        self.modelContainer = container
        self.modelContext = ModelContext(container)
    }

    func readGames() throws -> [QuestionsGridGameDTO] {
        let descriptor = FetchDescriptor<QuestionsGridGameModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let games = try modelContext.fetch(descriptor)
        return games.map { game in
            QuestionsGridGameDTO(from: game)
        }
    }

    func readGame(id: PersistentIdentifier) async throws -> QuestionsGridGameDTO {
        guard let game = modelContext.model(for: id) as? QuestionsGridGameModel else {
            throw DatabaseError.notFound
        }
        return QuestionsGridGameDTO(from: game)
    }

    func createGame(draft: QuestionsGridGameDraft) throws -> QuestionsGridGameDTO {
        let game = QuestionsGridGameModel(name: draft.name, topics: [], players: [], createdAt: draft.createdAt)
        modelContext.insert(game)
        try modelContext.save()
        return QuestionsGridGameDTO(from: game)
    }

    func updateGame(dto: QuestionsGridGameDTO) async throws {
        guard let game = modelContext.model(for: dto.id) as? QuestionsGridGameModel else {
            throw DatabaseError.notFound
        }
        game.name = dto.name
        game.createdAt = dto.createdAt
        try modelContext.save()
    }

    func deleteGame(id: PersistentIdentifier) throws {
        let game = modelContext.model(for: id)
        modelContext.delete(game)
        try modelContext.save()
    }

    func createTopic(draft: QuestionsGridTopicDraft, game: QuestionsGridGameDTO) async throws -> QuestionsGridTopicDTO {
        guard let game = modelContext.model(for: game.id) as? QuestionsGridGameModel else {
            throw DatabaseError.notFound
        }
        let topic = QuestionsGridTopicModel(name: draft.name, createdAt: draft.createdAt, questions: [])
        game.topics.append(topic)
        try modelContext.save()
        return QuestionsGridTopicDTO(from: topic)
    }

    func readTopic(id: PersistentIdentifier) async throws -> QuestionsGridTopicDTO {
        guard let topic = modelContext.model(for: id) as? QuestionsGridTopicModel else {
            throw DatabaseError.notFound
        }
        return QuestionsGridTopicDTO(from: topic)
    }

    func readTopics(ids: [PersistentIdentifier]) async throws -> [QuestionsGridTopicDTO] {
        let descriptor = FetchDescriptor<QuestionsGridTopicModel>(
            predicate: #Predicate { object in
                ids.contains(object.persistentModelID)
            }
        )
        let topics = try modelContext.fetch(descriptor)
        return topics.map { topic in
            QuestionsGridTopicDTO(from: topic)
        }
    }

    func updateTopic(dto: QuestionsGridTopicDTO) async throws {
        guard let topic = modelContext.model(for: dto.id) as? QuestionsGridTopicModel else {
            throw DatabaseError.notFound
        }
        topic.name = dto.name
        topic.createdAt = dto.createdAt
        try modelContext.save()
    }

    func deleteTopic(dto: QuestionsGridTopicDTO) async throws {
        let topic = modelContext.model(for: dto.id)
        modelContext.delete(topic)
        try modelContext.save()
    }

    func createQuestion(
        draft: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    ) async throws -> QuestionsGridQuestionDTO {
        guard let topic = modelContext.model(for: topic.id) as? QuestionsGridTopicModel else {
            throw DatabaseError.notFound
        }
        let medias = medias.map { media in
            QuestionsGridMediaModel(
                fileName: media.fileName,
                fileExtension: media.fileExtension,
                type: media.type,
                createdAt: media.createdAt
            )
        }
        let question = QuestionsGridQuestionModel(
            text: draft.text,
            medias: medias,
            answer: draft.answer,
            price: draft.price,
            isAnswered: draft.isAnswered
        )
        topic.questions.append(question)
        try modelContext.save()
        return QuestionsGridQuestionDTO(from: question)
    }

    func readQuestion(id: PersistentIdentifier) async throws -> QuestionsGridQuestionDTO {
        guard let question = modelContext.model(for: id) as? QuestionsGridQuestionModel else {
            throw DatabaseError.notFound
        }
        return QuestionsGridQuestionDTO(from: question)
    }

    func readQuestions(ids: [PersistentIdentifier]) async throws -> [QuestionsGridQuestionDTO] {
        let descriptor = FetchDescriptor<QuestionsGridQuestionModel>(
            predicate: #Predicate { object in
                ids.contains(object.persistentModelID)
            }
        )
        let questions = try modelContext.fetch(descriptor)
        return questions.map { question in
            QuestionsGridQuestionDTO(from: question)
        }
    }

    func updateQuestion(dto: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft]) async throws {
        guard let question = modelContext.model(for: dto.id) as? QuestionsGridQuestionModel else {
            throw DatabaseError.notFound
        }
        let newMedias = try readMediasAsModels(ids: dto.medias)
        question.medias = newMedias
        question.text = dto.text
        question.answer = dto.answer
        question.price = dto.price
        question.isAnswered = dto.isAnswered
        try modelContext.save()

        for media in medias {
            let _ = try await createMedia(draft: media, question: dto)
        }
    }

    func deleteQuestion(dto: QuestionsGridQuestionDTO) async throws {
        let question = modelContext.model(for: dto.id)
        modelContext.delete(question)
        try modelContext.save()
    }

    func createMedia(
        draft: QuestionsGridMediaDraft,
        question: QuestionsGridQuestionDTO
    ) async throws -> QuestionsGridMediaDTO {
        guard let question = modelContext.model(for: question.id) as? QuestionsGridQuestionModel else {
            throw DatabaseError.notFound
        }
        let media = QuestionsGridMediaModel(
            fileName: draft.fileName,
            fileExtension: draft.fileExtension,
            type: draft.type,
            createdAt: draft.createdAt
        )
        question.medias.append(media)
        try modelContext.save()
        return QuestionsGridMediaDTO(from: media)
    }

    func readMedias() async throws -> [QuestionsGridMediaDTO] {
        let descriptor = FetchDescriptor<QuestionsGridMediaModel>()
        let medias = try modelContext.fetch(descriptor)
        return medias.map { media in
            QuestionsGridMediaDTO(from: media)
        }
    }

    func readMedias(ids: [PersistentIdentifier]) async throws -> [QuestionsGridMediaDTO] {
        let medias = try readMediasAsModels(ids: ids)
        return medias.map { media in
            QuestionsGridMediaDTO(from: media)
        }
    }

    func createPlayer(
        draft: QuestionsGridPlayerDraft,
        game: QuestionsGridGameDTO
    ) async throws -> QuestionsGridPlayerDTO {
        guard let game = modelContext.model(for: game.id) as? QuestionsGridGameModel else {
            throw DatabaseError.notFound
        }
        let player = QuestionsGridPlayerModel(
            emoji: draft.emoji,
            name: draft.name,
            order: draft.order,
            score: draft.score
        )
        game.players.append(player)
        try modelContext.save()
        return QuestionsGridPlayerDTO(from: player)
    }

    func readPlayers(ids: [PersistentIdentifier]) async throws -> [QuestionsGridPlayerDTO] {
        let descriptor = FetchDescriptor<QuestionsGridPlayerModel>(
            predicate: #Predicate { object in
                ids.contains(object.persistentModelID)
            }
        )
        return try modelContext
            .fetch(descriptor)
            .map { player in
                QuestionsGridPlayerDTO(from: player)
            }
    }

    func updatePlayer(dto: QuestionsGridPlayerDTO) async throws {
        guard let player = modelContext.model(for: dto.id) as? QuestionsGridPlayerModel else {
            throw DatabaseError.notFound
        }
        player.emoji = dto.emoji
        player.name = dto.name
        player.order = dto.order
        player.score = dto.score
        try modelContext.save()
    }

    func deletePlayer(dto: QuestionsGridPlayerDTO) async throws {
        let player = modelContext.model(for: dto.id)
        modelContext.delete(player)
        try modelContext.save()
    }

    // MARK: - Private methods

    private func readMediasAsModels(ids: [PersistentIdentifier]) throws -> [QuestionsGridMediaModel] {
        let descriptor = FetchDescriptor<QuestionsGridMediaModel>(
            predicate: #Predicate { object in
                ids.contains(object.persistentModelID)
            }
        )
        return try modelContext.fetch(descriptor)
    }
}
