//
//  PlayerEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 31.01.2026.
//

import Observation

@Observable
final class PlayerEditorViewModel {
    var emoji: String
    var name: String

    init(emoji: String = "", name: String = "") {
        self.emoji = emoji
        self.name = name
    }
}
