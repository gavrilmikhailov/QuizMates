//
//  QuestionsGridGameModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation
import SwiftData

@Model
final class QuestionsGridGameModel {
    var name: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \QuestionsGridTopicModel.game)
    var topics: [QuestionsGridTopicModel]

    init(name: String, topics: [QuestionsGridTopicModel], createdAt: Date) {
        self.name = name
        self.topics = topics
        self.createdAt = createdAt
    }
}
