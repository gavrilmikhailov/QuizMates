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
    var isVideo: Bool
    var createdAt: Date

    init(fileName: String, fileExtension: String, isVideo: Bool, createdAt: Date) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.isVideo = isVideo
        self.createdAt = createdAt
    }
}
