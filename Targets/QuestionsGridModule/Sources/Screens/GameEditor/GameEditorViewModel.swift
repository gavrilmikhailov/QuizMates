//
//  GameEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 23.01.2026.
//

import Observation

@Observable
final class GameEditorViewModel {
    var name: String = ""
    var topics: [(TopicDTO, [QuestionDTO])] = []
    var players: [PlayerDTO] = []
    var progressState: GameEditorProgressState = .unableToStart
}

enum GameEditorProgressState {
    case unableToStart
    case readyToStart
    case inProgress
    case finished
}
