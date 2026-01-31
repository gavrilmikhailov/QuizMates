//
//  QuestionsGridPlayerDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import SwiftData

struct QuestionsGridPlayerDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let emoji: String
    let name: String
    let order: Int
    let score: Int

    init(id: PersistentIdentifier, emoji: String, name: String, order: Int, score: Int) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.order = order
        self.score = score
    }

    init(from model: QuestionsGridPlayerModel) {
        id = model.id
        emoji = model.emoji
        name = model.name
        order = model.order
        score = model.score
    }
}
