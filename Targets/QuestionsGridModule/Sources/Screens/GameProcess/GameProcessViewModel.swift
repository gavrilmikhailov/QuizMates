//
//  GameProcessViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 02.02.2026.
//

import Observation

@Observable
final class GameProcessViewModel {
    var title: String = ""
    var prices: [Int] = []
    var topics: [(TopicDTO, [QuestionDTO])] = []
    var players: [PlayerDTO] = []
}
