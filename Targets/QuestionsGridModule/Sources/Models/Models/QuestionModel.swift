//
//  QuestionModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import SwiftData

@Model
public final class QuestionModel {
    var text: String?
    var answer: String?
    var price: Int?
    var isAnswered: Bool?

    @Relationship(deleteRule: .cascade, inverse: \MediaModel.question)
    var medias: [MediaModel]? = []

    var topic: TopicModel?

    init(text: String, medias: [MediaModel], answer: String, price: Int, isAnswered: Bool) {
        self.text = text
        self.medias = medias
        self.answer = answer
        self.price = price
        self.isAnswered = isAnswered
    }

    init(draft: QuestionDraft) {
        self.text = draft.text
        self.answer = draft.answer
        self.price = draft.price
        self.isAnswered = draft.isAnswered
    }
}
