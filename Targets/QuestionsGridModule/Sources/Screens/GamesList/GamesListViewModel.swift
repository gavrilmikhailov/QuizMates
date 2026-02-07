//
//  GamesListViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import CoreModule
import Observation

@Observable
final class GamesListViewModel {

    // MARK: - Internal properties

    var viewState: ViewState = .loading
    var games: [GameDTO] = []
}
