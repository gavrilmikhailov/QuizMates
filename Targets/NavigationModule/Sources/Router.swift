//
//  Router.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

@MainActor
public final class Router {

    // MARK: - Private properties

    private let navigationController: UINavigationController

    // MARK: - Initializer

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Internal methods

    public func setRootView(_ controller: UIViewController) {
        navigationController.setViewControllers([controller], animated: false)
    }

    public func pushView(_ controller: UIViewController, animated: Bool, hideBottomBar: Bool) {
        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationController.pushViewController(controller, animated: animated)
    }

    public func popView(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    public func presentView(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(controller, animated: animated, completion: completion)
    }

    public func dismissView(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}
