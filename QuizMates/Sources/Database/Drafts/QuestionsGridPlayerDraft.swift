//
//  QuestionsGridPlayerDraft.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

struct QuestionsGridPlayerDraft: Sendable {
    let emoji: String
    let name: String
    let order: Int
    let score: Int

    init(emoji: String, name: String, order: Int, score: Int = 0) {
        self.emoji = emoji
        self.name = name
        self.order = order
        self.score = score
    }
}
