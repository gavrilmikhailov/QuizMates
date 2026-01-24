//
//  QuestionsGridTopicEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import Observation

@Observable
final class QuestionsGridTopicEditorViewModel {
    var name: String

    init(name: String = "") {
        self.name = name
    }
}
