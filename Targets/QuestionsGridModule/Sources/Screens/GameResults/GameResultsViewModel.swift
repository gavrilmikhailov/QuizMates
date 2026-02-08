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
}

struct GameResult: Identifiable {
    let place: Int
    let playerNames: String
    let score: Int

    var id: Int {
        place
    }
}
