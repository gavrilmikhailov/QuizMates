//
//  SceneDelegate.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import NavigationModule
import SwiftData
import QuestionsGridModule
@preconcurrency import Swinject
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Internal properties

    var window: UIWindow?

    // MARK: - Private properties

    private var appCoordinator: Coordinator?

    // MARK: - UIWindowSceneDelegate

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let rootController = UINavigationController()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        let assembler = Assembler([DatabaseAssembly(), UserDefaultsAssembly(), QuestionsGridAssembly()])

        appCoordinator = AppCoordinator(
            router: Router(navigationController: rootController),
            resolver: assembler.resolver
        )
        appCoordinator?.start()
    }
}
