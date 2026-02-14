//
//  UserDefaultsAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import Foundation
import UserDefaultsModule
@preconcurrency import Swinject

final class UserDefaultsAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.register(UserDefaultsServiceProtocol.self) { _ in
            return UserDefaultsService()
        }
        .inObjectScope(.container)
    }
}
