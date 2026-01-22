//
//  QuestionsGridInteractor.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData

protocol QuestionsGridInteractorProtocol: AnyObject {
}

final class QuestionsGridInteractor: QuestionsGridInteractorProtocol {

    // MARK: - Private properties

    private let presenter: QuestionsGridPresenterProtocol
    private let context: ModelContext

    // MARK: - Initializer

    init(presenter: QuestionsGridPresenterProtocol, context: ModelContext) {
        self.presenter = presenter
        self.context = context
    }
}
