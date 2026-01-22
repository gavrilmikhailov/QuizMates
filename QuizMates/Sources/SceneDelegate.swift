//
//  SceneDelegate.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

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

        appCoordinator = AppCoordinator(router: Router(navigationController: rootController))
        appCoordinator?.start()
    }
}
