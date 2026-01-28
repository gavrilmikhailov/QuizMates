//
//  QuestionsGridQuestionEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import Observation

@Observable
final class QuestionsGridQuestionEditorViewModel {
    var medias: [QuestionsGridMediaDTO]
    var mediaDrafts: [QuestionsGridMediaDraft]
    var questionText: String
    var questionAnswer: String
    var questionPrice: Int

    init(
        medias: [QuestionsGridMediaDTO] = [],
        mediaDrafts: [QuestionsGridMediaDraft] = [],
        questionText: String = "",
        questionAnswer: String = "",
        questionPrice: Int = 50
    ) {
        self.medias = medias
        self.mediaDrafts = mediaDrafts
        self.questionText = questionText
        self.questionAnswer = questionAnswer
        self.questionPrice = questionPrice
    }
}
