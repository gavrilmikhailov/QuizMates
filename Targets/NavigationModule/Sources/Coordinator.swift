//
//  Coordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

@preconcurrency import Swinject

@MainActor
public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var router: Router { get }
    var resolver: Resolver { get }

    func start()
    func retain(coordinator: Coordinator)
    func release(coordinator: Coordinator)
}
