//
//  QuestionsGridGameProcessQuestionViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 04.02.2026.
//

import Observation

@Observable
final class QuestionsGridGameProcessQuestionViewModel {
    var title: String
    var medias: [QuestionsGridMediaPreviewConfiguration]
    var text: String
    var answer: String
    var players: [QuestionsGridPlayerDTO]

    init(
        title: String = "",
        medias: [QuestionsGridMediaPreviewConfiguration] = [],
        text: String = "",
        answer: String = "",
        players: [QuestionsGridPlayerDTO] = []
    ) {
        self.title = title
        self.medias = medias
        self.text = text
        self.answer = answer
        self.players = players
    }
}
