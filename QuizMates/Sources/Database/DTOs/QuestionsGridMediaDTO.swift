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
    let type: String
    let data: Data
    let createdAt: Date

    init(from model: QuestionsGridMediaModel) {
        id = model.id
        fileName = model.fileName ?? ""
        fileExtension = model.fileExtension ?? ""
        type = model.type ?? ""
        data = model.data ?? Data()
        createdAt = model.createdAt ?? .now
    }

    func getTemporaryUrl() -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileUrl = tempDir.appendingPathComponent("\(UUID().uuidString).\(fileExtension)")

        if FileManager.default.fileExists(atPath: tempFileUrl.path) {
            return tempFileUrl
        }
        do {
            try data.write(to: tempFileUrl)
            return tempFileUrl
        } catch {
            print("Ошибка сохранения временного файла: \(error)")
            return nil
        }
    }
}
