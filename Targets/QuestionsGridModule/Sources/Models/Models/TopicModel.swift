//
//  TopicModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

@Model
public final class TopicModel {
    var name: String?
    var createdAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \QuestionModel.topic)
    var questions: [QuestionModel]? = []

    var game: GameModel?

    init(name: String, createdAt: Date, questions: [QuestionModel]) {
        self.name = name
        self.createdAt = createdAt
        self.questions = questions
    }

    init(draft: TopicDraft) {
        self.name = draft.name
        self.createdAt = draft.createdAt
    }
}
