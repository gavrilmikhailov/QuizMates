//
//  HelpersAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import SwiftData
@preconcurrency import Swinject

final class HelpersAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        container.register(MediaStorageService.self) { resolver in
            return MediaStorageService()
        }
        .inObjectScope(.container)
    }
}
