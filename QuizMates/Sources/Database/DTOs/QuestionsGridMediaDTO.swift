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

    var localURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mediaFolder = directory.appendingPathComponent("Media", isDirectory: true)

        // Создаем папку, если её нет
        try? FileManager.default.createDirectory(at: mediaFolder, withIntermediateDirectories: true)

        return mediaFolder.appendingPathComponent("\(fileName).\(fileExtension)")
    }

    func cleanUp() {
        try? FileManager.default.removeItem(at: localURL)
    }
}
