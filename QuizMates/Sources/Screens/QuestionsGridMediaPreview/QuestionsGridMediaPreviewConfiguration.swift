//
//  QuestionsGridMediaPreviewConfiguration.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 29.01.2026.
//

import Foundation

struct QuestionsGridMediaPreviewConfiguration {
    let fileName: String
    let fileExtension: String
    let type: String
    let data: Data

    func getTemporaryUrl() -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileUrl = tempDir.appendingPathComponent("\(fileName).\(fileExtension)")

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
