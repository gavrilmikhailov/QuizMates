//
//  QuestionsGridPresenter.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

protocol QuestionsGridPresenterProtocol: AnyObject {
}

final class QuestionsGridPresenter: QuestionsGridPresenterProtocol {

    // MARK: - Internal properties

    weak var view: QuestionsGridViewControllerProtocol?
}
