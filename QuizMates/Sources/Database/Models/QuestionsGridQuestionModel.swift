//
//  QuestionsGridQuestionModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import SwiftData

@Model
final class QuestionsGridQuestionModel {
    var text: String

    @Relationship(deleteRule: .cascade)
    var medias: [QuestionsGridMediaModel]

    var answer: String
    var price: Int
    var isAnswered: Bool
    var topic: QuestionsGridTopicModel?

    init(text: String, medias: [QuestionsGridMediaModel], answer: String, price: Int, isAnswered: Bool) {
        self.text = text
        self.medias = medias
        self.answer = answer
        self.price = price
        self.isAnswered = isAnswered
    }
}
