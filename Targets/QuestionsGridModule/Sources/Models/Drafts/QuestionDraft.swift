//
//  QuestionDraft.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation

struct QuestionDraft: Sendable {
    let text: String
    let answer: String
    let price: Int
    let isAnswered: Bool
}
