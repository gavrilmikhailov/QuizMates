//
//  DatabaseAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Foundation
import DatabaseModule
import QuestionsGridModule
import SwiftData
@preconcurrency import Swinject

final class DatabaseAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.register(ModelContainer.self) { _ in
            let schema = Schema(
                [
                    GameModel.self,
                    TopicModel.self,
                    QuestionModel.self,
                    MediaModel.self,
                    PlayerModel.self
                ]
            )
            let bundleId = Bundle.main.bundleIdentifier!
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .private("iCloud.\(bundleId)")
            )
            return try! ModelContainer(for: schema, configurations: [config])
        }
        .inObjectScope(.container)

        container.register(DatabaseServiceProtocol.self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            return DatabaseService(modelContainer: modelContainer)
        }
        .inObjectScope(.container)
    }
}
