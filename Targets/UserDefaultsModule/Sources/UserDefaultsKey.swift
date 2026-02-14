//
//  UserDefaultsKey.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

public struct UserDefaultsKey: RawRepresentable, Sendable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension UserDefaultsKey {
    static let gameProcessTopicFontSize = UserDefaultsKey(rawValue: "gameProcessTopicFontSize")
    static let gameProcessQuestionFontSize = UserDefaultsKey(rawValue: "gameProcessQuestionFontSize")
    static let gameProcessCellSize = UserDefaultsKey(rawValue: "gameProcessCellSize")
    static let gameProcessCellColor = UserDefaultsKey(rawValue: "gameProcessCellColor")
}
