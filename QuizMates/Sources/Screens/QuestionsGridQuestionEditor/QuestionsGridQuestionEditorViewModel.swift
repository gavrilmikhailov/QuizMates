//
//  QuestionsGridQuestionEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import Observation

@Observable
final class QuestionsGridQuestionEditorViewModel {
    var questionText: String
    var questionAnswer: String
    var questionPrice: Int

    init(
        questionText: String = "",
        questionAnswer: String = "",
        questionPrice: Int = 50
    ) {
        self.questionText = questionText
        self.questionAnswer = questionAnswer
        self.questionPrice = questionPrice
    }
}
