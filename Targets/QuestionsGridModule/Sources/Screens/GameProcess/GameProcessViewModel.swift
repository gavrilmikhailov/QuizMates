//
//  GameProcessViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import SwiftUI

@Observable
final class GameProcessViewModel {
    var title: String = ""
    var prices: [Int] = []
    var topics: [(TopicDTO, [QuestionDTO])] = []
    var players: [PlayerDTO] = []

    var topicFontSize: CGFloat = 16
    var questionFontSize: CGFloat = 24
    var cellSize: CGFloat = 100
    var cellColor: Color = .blue
}
