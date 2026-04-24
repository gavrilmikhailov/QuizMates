//
//  PlayerDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import Foundation
import SwiftData

struct PlayerDTO: Sendable, Identifiable, Equatable {
    let id: PersistentIdentifier
    let emoji: String
    let name: String
    let score: Int
    let createdAt: Date

    init(id: PersistentIdentifier, emoji: String, name: String, score: Int, createdAt: Date) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.score = score
        self.createdAt = createdAt
    }

    init(from model: QuestionsGridPlayerModel) {
        id = model.persistentModelID
        emoji = model.emoji ?? ""
        name = model.name ?? ""
        score = model.score ?? 0
        createdAt = model.createdAt ?? .now
    }
}
