//
//  GameProcessSettingsView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import SwiftUI

struct GameProcessSettingsView: View {

    @State private var topicFontSize: CGFloat
    @State private var questionFontSize: CGFloat
    @State private var playerNameFontSize: CGFloat
    @State private var cellSize: CGFloat
    @State private var selectedColorPreset: ColorPreset

    private let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    weak var delegate: GameProcessSettingsDelegate?

    init(configuration: GameProcessSettingsConfiguration, delegate: GameProcessSettingsDelegate?) {
        self.topicFontSize = configuration.topicFontSize
        self.questionFontSize = configuration.questionFontSize
        self.playerNameFontSize = configuration.playerNameFontSize
        self.cellSize = configuration.cellSize
        self.selectedColorPreset = configuration.cellColor
        self.delegate = delegate
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.fontSizeTopic(Int(topicFontSize)))
                        .font(.system(size: 10))
                    Slider(value: $topicFontSize, in: 10...100, step: 1)
                        .onChange(of: topicFontSize) { _, newValue in
                            delegate?.didChangeTopicFontSize(value: newValue)
                        }
                }
                Divider()
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
                    Slider(value: $playerNameFontSize, in: 10...100, step: 1)
                        .onChange(of: playerNameFontSize) { _, newValue in
                            delegate?.didChangePlayerNameFontSize(value: newValue)
                        }
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.cellSize(Int(cellSize)))
                        .font(.system(size: 10))
                    Slider(value: $cellSize, in: 50...250, step: 10)
                        .onChange(of: cellSize) {_,  newValue in
                            delegate?.didChangeCellSize(value: newValue)
                        }
                }
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.cellColor)
                        .font(.system(size: 10))
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(ColorPreset.allCases, id: \.self) { colorPreset in
                            ZStack {
                                Circle()
                                    .fill(Color(preset: colorPreset))
                                    .frame(width: 40, height: 40)
                                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                                if selectedColorPreset == colorPreset {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                        .shadow(color: .black.opacity(0.3), radius: 1)
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedColorPreset = colorPreset
                                    delegate?.didChangeCellColor(value: colorPreset)
                                }
                            }
                        }
                    }
                }
            }
            .padding(top: 40, leading: 16, bottom: 0, trailing: 16)
        }
        .frame(width: 200)
    }
}
