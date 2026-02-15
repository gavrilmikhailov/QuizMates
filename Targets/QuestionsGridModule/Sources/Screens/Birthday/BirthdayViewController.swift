//
//  BirthdayViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 15.02.2026.
//

import SwiftUI

final class BirthdayViewController: UIHostingController<BirthdayView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?

    // MARK: - Private properties

    private let viewModel: BirthdayViewModel

    // MARK: - Initializer

    init(viewModel: BirthdayViewModel, rootView: BirthdayView) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .clear
    }

    private func startAnimation() {
        UIView.animate(
            withDuration: 1.5,
            animations: { [weak self] in
                self?.view.backgroundColor = .black.withAlphaComponent(0.9)
            },
            completion: { [weak self] _ in
                self?.viewModel.opacity = 1
                withAnimation(.linear(duration: 2)) {
                    self?.viewModel.offset = 0
                } completion: {
                    self?.viewModel.confettiToggle.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.viewModel.fireworksOn = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            self?.onClose?()
                        }
                    }
                }
            }
        )
    }
}
