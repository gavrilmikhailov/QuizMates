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
    var name: String
    var order: Int
    var score: Int

    var game: QuestionsGridGameModel?

    init(name: String, order: Int, score: Int) {
        self.name = name
        self.order = order
        self.score = score
    }
}
