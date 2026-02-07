//
//  TopicEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import Observation

@Observable
final class TopicEditorViewModel {
    var name: String

    init(name: String = "") {
        self.name = name
    }
}
