//
//  GameResultsViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import Observation

@Observable
final class GameResultsViewModel {
    var results: [GameResult] = []
    var confettiToggle: Bool = false
}

struct GameResult: Identifiable {
    let placeEmoji: String
    let place: Int
    let playerNames: String
    let score: String

    var id: Int {
        place
    }
}
