//
//  QuestionsGridMediaDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

struct QuestionsGridMediaDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let fileName: String
    let fileExtension: String
    let createdAt: Date

    init(from model: QuestionsGridMediaModel) {
        id = model.id
        fileName = model.fileName
        fileExtension = model.fileExtension
        createdAt = model.createdAt
    }
}
