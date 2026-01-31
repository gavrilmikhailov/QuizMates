//
//  QuestionsGridPlayerModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import Foundation
import SwiftData

@Model
final class QuestionsGridPlayerModel {
    var emoji: String
    var name: String
    var order: Int
    var score: Int

    var game: QuestionsGridGameModel?

    init(emoji: String, name: String, order: Int, score: Int) {
        self.emoji = emoji
        self.name = name
        self.order = order
        self.score = score
    }
}
