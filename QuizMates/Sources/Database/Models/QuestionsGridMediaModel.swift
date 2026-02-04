//
//  QuestionsGridMediaModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

@Model
final class QuestionsGridMediaModel {
    var fileName: String?
    var fileExtension: String?
    var type: String?
    var createdAt: Date?

    @Attribute(.externalStorage)
    var data: Data?

    var question: QuestionsGridQuestionModel?

    init(fileName: String, fileExtension: String, type: String, data: Data, createdAt: Date) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.type = type
        self.data = data
        self.createdAt = createdAt
    }
}
