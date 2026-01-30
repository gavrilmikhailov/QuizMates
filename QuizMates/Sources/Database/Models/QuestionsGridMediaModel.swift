//
//  QuestionsGridMediaModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

@Model
class QuestionsGridMediaModel {
    var fileName: String
    var fileExtension: String
    var type: String
    var createdAt: Date

    init(fileName: String, fileExtension: String, type: String, createdAt: Date) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.type = type
        self.createdAt = createdAt
    }
}
