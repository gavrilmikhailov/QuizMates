//
//  BaseCoordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit
@preconcurrency import Swinject

@MainActor
open class BaseCoordinator: Coordinator {

    // MARK: - Public properties

    public var childCoordinators: [Coordinator] = []
    public let router: Router
    public let resolver: Resolver

    // MARK: - Initializer

    public init(router: Router, resolver: Resolver) {
        self.router = router
        self.resolver = resolver
    }

    // MARK: - Public methods

    open func start() {
    }

    public func retain(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    public func release(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
