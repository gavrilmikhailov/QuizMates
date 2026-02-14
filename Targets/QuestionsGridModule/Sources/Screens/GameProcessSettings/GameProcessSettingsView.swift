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
    @State private var cellSize: CGFloat
    @State private var selectedColor: Color

    private let presets: [Color] = [
        .red, .orange, .yellow, .green, .mint,
        .teal, .cyan, .blue, .indigo, .purple,
        .pink, .brown, .gray, .black
    ]
    private let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    weak var delegate: GameProcessSettingsDelegate?

    init(configuration: GameProcessSettingsConfiguration, delegate: GameProcessSettingsDelegate?) {
        self.topicFontSize = configuration.topicFontSize
        self.questionFontSize = configuration.questionFontSize
        self.cellSize = configuration.cellSize
        self.selectedColor = configuration.cellColor
        self.delegate = delegate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text(Strings.fontSizeTopic(Int(topicFontSize)))
                    .font(.headline)
                Slider(value: $topicFontSize, in: 10...200, step: 1)
                    .onChange(of: topicFontSize) { _, newValue in
                        delegate?.didChangeTopicFontSize(value: newValue)
                    }
            }
            Divider()
            VStack(alignment: .leading) {
                Text(Strings.fontSizeQuestion(Int(questionFontSize)))
                    .font(.headline)
                Slider(value: $questionFontSize, in: 10...200, step: 1)
                    .onChange(of: questionFontSize) { _, newValue in
                        delegate?.didChangeQuestionFontSize(value: newValue)
                    }
            }
            Divider()
            VStack(alignment: .leading) {
                Text(Strings.cellSize(Int(cellSize)))
                    .font(.headline)
                Slider(value: $cellSize, in: 50...500, step: 10)
                    .onChange(of: cellSize) {_,  newValue in
                        delegate?.didChangeCellSize(value: newValue)
                    }
            }
            Divider()
            VStack(alignment: .leading) {
                Text(Strings.cellColor)
                    .font(.headline)
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(presets, id: \.self) { color in
                        ZStack {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                            if selectedColor == color {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                                    .shadow(color: .black.opacity(0.3), radius: 1)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedColor = color
                                delegate?.didChangeCellColor(value: color)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}
