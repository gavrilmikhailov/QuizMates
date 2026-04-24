//
//  GameProcessQuestionSettingsView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.04.2026.
//

import SwiftUI

struct GameProcessQuestionSettingsView: View {

    @State private var questionFontSize: CGFloat
    @State private var playerNameFontSize: CGFloat

    weak var delegate: GameProcessQuestionSettingsDelegate?

    init(configuration: GameProcessQuestionSettingsConfiguration, delegate: GameProcessQuestionSettingsDelegate?) {
        self.questionFontSize = configuration.questionFontSize
        self.playerNameFontSize = configuration.playerNameFontSize
        self.delegate = delegate
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.fontSizeQuestion(Int(questionFontSize)))
                        .font(.system(size: 10))
                    Slider(value: $questionFontSize, in: 10...100, step: 1)
                        .onChange(of: questionFontSize) { _, newValue in
                            delegate?.didChangeQuestionFontSize(value: newValue)
                        }
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.fontSizePlayerName(Int(playerNameFontSize)))
                        .font(.system(size: 10))
                    Slider(value: $playerNameFontSize, in: 1...36, step: 1)
                        .onChange(of: playerNameFontSize) { _, newValue in
                            delegate?.didChangePlayerNameFontSize(value: newValue)
                        }
                }
            }
            .padding(top: 40, leading: 16, bottom: 0, trailing: 16)
        }
        .frame(width: 200)
    }
}
