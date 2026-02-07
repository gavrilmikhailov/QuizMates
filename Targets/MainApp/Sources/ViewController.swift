//
//  ViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import UIKit

final class ViewController: UIViewController {

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
        view.backgroundColor = .systemRed
    }
}
