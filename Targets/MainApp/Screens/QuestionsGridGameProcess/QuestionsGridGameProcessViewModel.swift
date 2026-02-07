//
//  QuestionsGridGameProcessViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import Observation

@Observable
final class QuestionsGridGameProcessViewModel {
    var title: String = ""
    var prices: [Int] = []
    var topics: [(QuestionsGridTopicDTO, [QuestionsGridQuestionDTO])] = []
    var players: [QuestionsGridPlayerDTO] = []
}
