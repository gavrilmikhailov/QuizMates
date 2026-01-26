//
//  QuestionsGridTopicEditorMode.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 26.01.2026.
//

enum QuestionsGridTopicEditorMode {
    case createNewTopic(QuestionsGridTopicDraft)
    case editExistingTopic(QuestionsGridTopicDTO)
}
