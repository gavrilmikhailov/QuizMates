//
//  QuestionsGridTopicDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

struct QuestionsGridTopicDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let name: String
    let createdAt: Date
    let questions: [PersistentIdentifier]

    internal init(
        id: PersistentIdentifier,
        name: String,
        createdAt: Date,
        questions: [PersistentIdentifier]
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.questions = questions
    }

    init(from model: QuestionsGridTopicModel) {
        id = model.id
        name = model.name ?? ""
        createdAt = model.createdAt ?? .now
        questions = model.questions?.map(\.id) ?? []
    }
}
