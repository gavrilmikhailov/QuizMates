//
//  GameProcessViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@Observable
final class GameProcessViewModel {
    var title: String
    var prices: [Int]
    var topics: [(TopicDTO, [QuestionDTO])]
    var players: [PlayerDTO]

    var topicFontSize: CGFloat
    var questionFontSize: CGFloat
    var cellSize: CGFloat
    var cellColor: ColorPreset

    init(
        title: String = "",
        prices: [Int] = [],
        topics: [(TopicDTO, [QuestionDTO])] = [],
        players: [PlayerDTO] = [],
        topicFontSize: CGFloat = 16,
        questionFontSize: CGFloat = 24,
        cellSize: CGFloat = 100,
        cellColor: ColorPreset = .blue
    ) {
        self.title = title
        self.prices = prices
        self.topics = topics
        self.players = players
        self.topicFontSize = topicFontSize
        self.questionFontSize = questionFontSize
        self.cellSize = cellSize
        self.cellColor = cellColor
    }
}
