//
//  PlayerModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import Foundation
import SwiftData

@Model
public final class PlayerModel {
    var emoji: String?
    var name: String?
    var score: Int?
    var createdAt: Date?

    var game: GameModel?

    init(emoji: String, name: String, score: Int, createdAt: Date) {
        self.emoji = emoji
        self.name = name
        self.score = score
        self.createdAt = createdAt
    }

    init(draft: PlayerDraft) {
        emoji = draft.emoji
        name = draft.name
        score = draft.score
        createdAt = draft.createdAt
    }
}
