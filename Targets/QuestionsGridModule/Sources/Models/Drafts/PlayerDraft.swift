//
//  PlayerDraft.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import Foundation

struct PlayerDraft: Sendable {
    let emoji: String
    let name: String
    let score: Int
    let createdAt: Date

    init(emoji: String, name: String, score: Int = 0, createdAt: Date) {
        self.emoji = emoji
        self.name = name
        self.score = score
        self.createdAt = createdAt
    }
}
