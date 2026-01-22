//
//  DatabaseAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData
import Swinject

final class DatabaseAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.register(ModelContainer.self) { _ in
            let schema = Schema([QuestionsGridGameModel.self, QuestionsGridTopicModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try! ModelContainer(for: schema, configurations: [config])
        }
        .inObjectScope(.container)

        container.register(ModelContext.self) { resolver in
            let modelContainer = resolver.resolve(ModelContainer.self)!
            return ModelContext(modelContainer)
        }
        .inObjectScope(.container)
    }
}
