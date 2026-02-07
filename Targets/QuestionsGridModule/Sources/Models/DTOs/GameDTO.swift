//
//  GameDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

struct GameDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let name: String
    let createdAt: Date
    let topics: [PersistentIdentifier]
    let players: [PersistentIdentifier]

    init(
        id: PersistentIdentifier,
        name: String,
        createdAt: Date,
        topics: [PersistentIdentifier],
        players: [PersistentIdentifier]
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.topics = topics
        self.players = players
    }

    init(from model: GameModel) {
        id = model.persistentModelID
        name = model.name ?? ""
        createdAt = model.createdAt ?? .now
        topics = model.topics?.map(\.id) ?? []
        players = model.players?.map(\.id) ?? []
    }
}
