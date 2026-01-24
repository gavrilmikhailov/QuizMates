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

@Model
final class QuestionsGridTopicModel {
    var name: String
    var createdAt: Date
    var game: QuestionsGridGameModel?

    @Relationship(deleteRule: .cascade, inverse: \QuestionsGridQuestionModel.topic)
    var questions: [QuestionsGridQuestionModel]

    init(name: String, createdAt: Date, questions: [QuestionsGridQuestionModel]) {
        self.name = name
        self.createdAt = createdAt
        self.questions = questions
    }
}

@Model
final class QuestionsGridQuestionModel {
    var text: String
    var answer: String
    var price: Int
    var isAnswered: Bool
    var topic: QuestionsGridTopicModel?

    init(text: String, answer: String, price: Int, isAnswered: Bool) {
        self.text = text
        self.answer = answer
        self.price = price
        self.isAnswered = isAnswered
    }
}
