//
//  GameProcessQuestionSettingsViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.04.2026.
//

import SwiftUI

@MainActor
protocol GameProcessQuestionSettingsDelegate: AnyObject {
    func didChangeQuestionFontSize(value: CGFloat)
    func didChangePlayerNameFontSize(value: CGFloat)
}

final class GameProcessQuestionSettingsViewController: UIHostingController<GameProcessQuestionSettingsView> {
}
