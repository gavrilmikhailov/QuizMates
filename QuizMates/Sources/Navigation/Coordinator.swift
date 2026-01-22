//
//  Coordinator.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import Swinject

class Coordinator {

    // MARK: - Internal properties

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
}
