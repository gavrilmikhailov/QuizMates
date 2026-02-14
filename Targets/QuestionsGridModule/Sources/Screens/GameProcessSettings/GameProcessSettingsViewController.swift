//
//  GameProcessSettingsViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import SwiftUI

@MainActor
protocol GameProcessSettingsDelegate: AnyObject {
    func didChangeTopicFontSize(value: CGFloat)
    func didChangeQuestionFontSize(value: CGFloat)
    func didChangePlayerNameFontSize(value: CGFloat)
    func didChangeCellSize(value: CGFloat)
    func didChangeCellColor(value: ColorPreset)
}

final class GameProcessSettingsViewController: UIHostingController<GameProcessSettingsView> {
}
