//
//  MainViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

final class MainViewController: UITabBarController {

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        if #available(iOS 18, *) {
            tabs = [
                UITab(
                    title: "Первая игра",
                    image: UIImage(systemName: "1.circle"),
                    identifier: "First game",
                    viewControllerProvider: { tab in
                        let controller = UIViewController()
                        controller.view.backgroundColor = .systemGreen
                        return controller
                    }
                ),
                UITab(
                    title: "Вторая игра",
                    image: UIImage(systemName: "2.circle"),
                    identifier: "Second game",
                    viewControllerProvider: { tab in
                        let controller = UIViewController()
                        controller.view.backgroundColor = .systemRed
                        return controller
                    }
                ),
                UITab(
                    title: "Третья игра",
                    image: UIImage(systemName: "3.circle"),
                    identifier: "Third game",
                    viewControllerProvider: { tab in
                        let controller = UIViewController()
                        controller.view.backgroundColor = .systemBlue
                        return controller
                    }
                )
            ]
        }
    }
}
