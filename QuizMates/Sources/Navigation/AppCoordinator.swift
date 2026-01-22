//
//  AppCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

final class AppCoordinator: Coordinator {

    // MARK: - Coordinator

    override func start() {
        showRoot()
    }

    // MARK: - Private methods

    private func showRoot() {
        let view = QuestionsGridConfigurator().configure()

        router.setRootView(view)
    }
}
