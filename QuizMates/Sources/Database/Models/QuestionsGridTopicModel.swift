//
//  QuestionsGridTopicModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

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
