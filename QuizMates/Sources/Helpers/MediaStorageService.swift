//
//  MediaStorageService.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

/*
import Foundation
import SwiftData
import UIKit

protocol MediaStorageServiceProtocol {
    func saveImage(data: Data, for item: MediaItem) throws
    func remove(item: MediaItem)
    @MainActor
    func removeOrphanedItems(modelContext: ModelContext)
}

actor MediaStorageService {

    // MARK: - Internal methods

    func saveImage(data: Data, for item: MediaItem) throws {
        if let image = UIImage(data: data), let compressedData = image.jpegData(compressionQuality: 0.8) {
            try compressedData.write(to: item.localURL, options: .atomic)
        } else {
            try data.write(to: item.localURL, options: .atomic)
        }
    }

    func remove(item: MediaItem) {
        try? FileManager.default.removeItem(at: item.localURL)
    }

    @MainActor
    func removeOrphanedItems(modelContext: ModelContext) {
        Task(priority: .background) {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let mediaFolder = directory.appendingPathComponent("Media", isDirectory: true)

            // 1. Получаем список всех файлов на диске
            guard let filesOnDisk = try? FileManager.default.contentsOfDirectory(
                at: mediaFolder,
                includingPropertiesForKeys: nil
            ) else {
                return
            }

            // 2. Получаем ID из базы данных (делаем это аккуратно через FetchDescriptor)
            let descriptor = FetchDescriptor<MediaItem>()
            // Чтобы не грузить память, запрашиваем только необходимые данные
            let itemsInDB = (try? modelContext.fetch(descriptor)) ?? []
            let validFileNames = Set(itemsInDB.map { "\($0.id.uuidString).\($0.fileExtension)" })

            // 3. Сверяем и удаляем
            for fileURL in filesOnDisk {
                let fileName = fileURL.lastPathComponent

                // Пропускаем системные папки и файлы, если они есть
                if fileName.hasPrefix(".") || fileName == "default.store" {
                    continue
                }

                if !validFileNames.contains(fileName) {
                    try? FileManager.default.removeItem(at: fileURL)
                    print("🗑️ Удален мусорный файл: \(fileName)")
                }
            }
        }
    }
}
*/
