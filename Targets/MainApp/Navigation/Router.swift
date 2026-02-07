//
//  Router.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

@MainActor
final class Router {

    // MARK: - Private properties

    private let navigationController: UINavigationController

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal methods

    func setRootView(_ controller: UIViewController) {
        navigationController.setViewControllers([controller], animated: false)
    }

    func pushView(_ controller: UIViewController, animated: Bool, hideBottomBar: Bool) {
        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationController.pushViewController(controller, animated: animated)
    }

    func presentView(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(controller, animated: animated, completion: completion)
    }

    func dismissView(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}
