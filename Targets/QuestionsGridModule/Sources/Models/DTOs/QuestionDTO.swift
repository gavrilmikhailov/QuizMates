//
//  QuestionDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

struct QuestionDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let medias: [PersistentIdentifier]
    let text: String
    let answer: String
    let price: Int
    let isAnswered: Bool

    init(
        id: PersistentIdentifier,
        medias: [PersistentIdentifier],
        text: String,
        answer: String,
        price: Int,
        isAnswered: Bool
    ) {
        self.id = id
        self.medias = medias
        self.text = text
        self.answer = answer
        self.price = price
        self.isAnswered = isAnswered
    }

    init(from model: QuestionsGridQuestionModel) {
        id = model.persistentModelID
        medias = model.medias?.map(\.id) ?? []
        text = model.text ?? ""
        answer = model.answer ?? ""
        price = model.price ?? 0
        isAnswered = model.isAnswered ?? false
    }
}
