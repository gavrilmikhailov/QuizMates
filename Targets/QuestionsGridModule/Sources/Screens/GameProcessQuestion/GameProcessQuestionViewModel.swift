//
//  GameProcessQuestionViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import SwiftUI

@Observable
final class GameProcessQuestionViewModel {
    var price: Int
    var medias: [MediaPreviewConfiguration]
    var text: String
    var answer: String
    var players: [PlayerDTO]

    var questionFontSize: CGFloat
    var playerNameFontSize: CGFloat

    init(
        price: Int = 0,
        medias: [MediaPreviewConfiguration] = [],
        text: String = "",
        answer: String = "",
        players: [PlayerDTO] = [],

        questionFontSize: CGFloat = 72,
        playerNameFontSize: CGFloat = 16
    ) {
        self.price = price
        self.medias = medias
        self.text = text
        self.answer = answer
        self.players = players
        self.questionFontSize = questionFontSize
        self.playerNameFontSize = playerNameFontSize
    }
}
