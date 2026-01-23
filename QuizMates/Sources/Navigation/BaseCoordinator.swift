//
//  BaseCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit
import Swinject

class BaseCoordinator: Coordinator {

    // MARK: - Internal properties

    weak var finisherDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    let router: Router
    let resolver: Resolver

    // MARK: - Initializer

    init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    // MARK: - Internal methods

    func start() {
    }

    // Retains child coordinator
    func retain(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    // Releases child coordinator
    func release(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
