//
//  AppCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import NavigationModule
import QuestionsGridModule
import UIKit

@MainActor
final class AppCoordinator: BaseCoordinator {

    // MARK: - Coordinator

    override func start() {
        let coordinator = QuestionsGridCoordinator(router: router, resolver: resolver)
        retain(coordinator: coordinator)
        coordinator.start()
    }
}
