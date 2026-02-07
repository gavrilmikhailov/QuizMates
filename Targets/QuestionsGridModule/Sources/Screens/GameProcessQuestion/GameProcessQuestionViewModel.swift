//
//  GameProcessQuestionViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import Observation

@Observable
final class GameProcessQuestionViewModel {
    var title: String
    var medias: [MediaPreviewConfiguration]
    var text: String
    var answer: String
    var players: [PlayerDTO]

    init(
        title: String = "",
        medias: [MediaPreviewConfiguration] = [],
        text: String = "",
        answer: String = "",
        players: [PlayerDTO] = []
    ) {
        self.title = title
        self.medias = medias
        self.text = text
        self.answer = answer
        self.players = players
    }
}
