//
//  MediaStorageService.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData
import UIKit

protocol MediaStorageService: Actor {
    func saveImage(data: Data, for item: QuestionsGridMediaDTO) throws
    func remove(item: QuestionsGridMediaDTO)
    func removeOrphanedItems() async
}

actor MediaStorageActor: MediaStorageService {

    // MARK: - Private properties

    private let databaseService: DatabaseService

    // MARK: - Initializer

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    // MARK: - MediaStorageService

    func saveImage(data: Data, for item: QuestionsGridMediaDTO) throws {
        if let image = UIImage(data: data), let compressedData = image.jpegData(compressionQuality: 0.8) {
            try compressedData.write(to: item.localURL, options: .atomic)
        } else {
            try data.write(to: item.localURL, options: .atomic)
        }
    }

    func remove(item: QuestionsGridMediaDTO) {
        try? FileManager.default.removeItem(at: item.localURL)
    }

    func removeOrphanedItems() async {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mediaFolder = directory.appendingPathComponent("Media", isDirectory: true)

        // 1. Получаем список всех файлов на диске
        guard let filesOnDisk = try? FileManager.default.contentsOfDirectory(
            at: mediaFolder,
            includingPropertiesForKeys: nil
        ) else {
            return
        }

        do {
            let medias = try await databaseService.readMedias()
            let fileNames = Set(medias.map { "\($0.fileName).\($0.fileExtension)" })

            // 3. Сверяем и удаляем
            for fileURL in filesOnDisk {
                let fileName = fileURL.lastPathComponent

                // Пропускаем системные папки и файлы, если они есть
                if fileName.hasPrefix(".") || fileName == "default.store" {
                    continue
                }

                if !fileNames.contains(fileName) {
                    try FileManager.default.removeItem(at: fileURL)
                    print("🗑️ Удален мусорный файл: \(fileName)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
