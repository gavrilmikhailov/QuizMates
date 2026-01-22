//
//  QuestionsGridProvider.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData

final class QuestionsGridProvider {

    // MARK: - Internal properties

    let container: ModelContainer
    let context: ModelContext

    // MARK: - Initializer

    init() {
        let schema = Schema([QuestionsGridGameModel.self, QuestionsGridTopicModel.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: schema, configurations: [config])
            context = ModelContext(container)
        } catch {
            fatalError("Не удалось инициализировать SwiftData")
        }
    }
}
