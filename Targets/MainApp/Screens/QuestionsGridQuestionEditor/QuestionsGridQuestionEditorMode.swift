//
//  QuestionsGridQuestionEditorMode.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 26.01.2026.
//

enum QuestionsGridQuestionEditorMode {
    case createNewQuestion(QuestionsGridQuestionDraft)
    case editExistingQuestion(QuestionsGridQuestionDTO)
}
