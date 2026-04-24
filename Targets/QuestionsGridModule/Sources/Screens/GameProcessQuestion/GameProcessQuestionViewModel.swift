//
//  GameProcessQuestionViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import Observation

@Observable
final class GameProcessQuestionViewModel {
    var price: Int
    var medias: [MediaPreviewConfiguration]
    var text: String
    var answer: String
    var players: [PlayerDTO]

    init(
        price: Int = 0,
        medias: [MediaPreviewConfiguration] = [],
        text: String = "",
        answer: String = "",
        players: [PlayerDTO] = []
    ) {
        self.price = price
        self.medias = medias
        self.text = text
        self.answer = answer
        self.players = players
    }
}
