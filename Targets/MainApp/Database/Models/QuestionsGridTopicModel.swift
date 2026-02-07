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
    var name: String?
    var createdAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \QuestionsGridQuestionModel.topic)
    var questions: [QuestionsGridQuestionModel]? = []

    var game: QuestionsGridGameModel?

    init(name: String, createdAt: Date, questions: [QuestionsGridQuestionModel]) {
        self.name = name
        self.createdAt = createdAt
        self.questions = questions
    }
}
