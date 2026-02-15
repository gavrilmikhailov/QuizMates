//
//  BirthdayViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 15.02.2026.
//

import CoreGraphics
import Observation

@Observable
final class BirthdayViewModel {
    var opacity: CGFloat = 0
    var offset: CGFloat = -500
    var confettiToggle: Bool = false
    var fireworksOn: Bool = false
}
