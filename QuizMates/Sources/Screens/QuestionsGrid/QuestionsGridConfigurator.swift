//
//  QuestionsGridConfigurator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

final class QuestionsGridConfigurator {

    func configure() -> UIViewController {
        let viewController = QuestionsGridViewController(rootView: QuestionsGridView())
        return viewController
    }
}
