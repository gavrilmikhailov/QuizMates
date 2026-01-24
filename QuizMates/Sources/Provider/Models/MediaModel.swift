//
//  MediaModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

@Model
class MediaItem {
    var id: UUID
    var fileName: String
    var fileExtension: String
    var createdAt: Date

    init(fileName: String, fileExtension: String) {
        self.id = UUID()
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.createdAt = .now
    }

    @Transient
    var localURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mediaFolder = directory.appendingPathComponent("Media", isDirectory: true)

        // Создаем папку, если её нет
        try? FileManager.default.createDirectory(at: mediaFolder, withIntermediateDirectories: true)

        return mediaFolder.appendingPathComponent("\(id.uuidString).\(fileExtension)")
    }

    func cleanUp() {
        try? FileManager.default.removeItem(at: localURL)
    }
}
