//
//  QuestionsGridGameModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation
import SwiftData

@Model
public final class QuestionsGridGameModel {
    var name: String?
    var createdAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \QuestionsGridTopicModel.game)
    var topics: [QuestionsGridTopicModel]? = []

    @Relationship(deleteRule: .cascade, inverse: \QuestionsGridPlayerModel.game)
    var players: [QuestionsGridPlayerModel]? = []

    init(name: String, topics: [QuestionsGridTopicModel], players: [QuestionsGridPlayerModel], createdAt: Date) {
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
