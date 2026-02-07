//
//  GameModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation
import SwiftData

@Model
public final class GameModel {
    var name: String?
    var createdAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \TopicModel.game)
    var topics: [TopicModel]? = []

    @Relationship(deleteRule: .cascade, inverse: \PlayerModel.game)
    var players: [PlayerModel]? = []

    init(name: String, topics: [TopicModel], players: [PlayerModel], createdAt: Date) {
        self.name = name
        self.topics = topics
        self.players = players
        self.createdAt = createdAt
    }

    init(draft: GameDraft) {
        self.name = draft.name
        self.topics = []
        self.players = []
        self.createdAt = draft.createdAt
    }
}
