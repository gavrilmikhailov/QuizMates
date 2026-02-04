//
//  QuestionsGridMediaDraft.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation

struct QuestionsGridMediaDraft: Sendable, Identifiable {
    let id: UUID
    let fileName: String
    let fileExtension: String
    let type: String
    let data: Data
    let createdAt: Date

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
