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
    let isVideo: Bool
    let createdAt: Date

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
