//
//  Coordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Swinject

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var finisherDelegate: CoordinatorFinishDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var router: Router { get }
    var resolver: Resolver { get }

    func start()
}
