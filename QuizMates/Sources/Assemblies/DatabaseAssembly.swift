//
//  DatabaseAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData
@preconcurrency import Swinject

final class DatabaseAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.register(ModelContainer.self) { _ in
            let schema = Schema(
                [
                    QuestionsGridGameModel.self,
                    QuestionsGridTopicModel.self,
                    QuestionsGridQuestionModel.self,
                    QuestionsGridMediaModel.self
                ]
            )
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try! ModelContainer(for: schema, configurations: [config])
        }
        .inObjectScope(.container)

        container.register(DatabaseService.self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            return DatabaseActor(container: modelContainer)
        }
        .inObjectScope(.container)
    }
}
