//
//  AddMediaView.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import SwiftUI
import PhotosUI
import SwiftData

//struct AddMediaView: View {
//    @Environment(\.modelContext) private var modelContext
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var isProcessing = false
//
//    var body: some View {
//        PhotosPicker(selection: $selectedItem, matching: .images) {
//            Label("Добавить фото", systemImage: "plus.circle.fill")
//                // .symbolVariant(.inset)
//                .font(.title2)
//        }
//        .disabled(isProcessing)
//        .overlay {
//            if isProcessing { ProgressView() }
//        }
//        .onChange(of: selectedItem) { _, newItem in
//            if let newItem {
//                Task {
//                    await processSelection(newItem)
//                }
//            }
//        }
//    }
//
//    @MainActor
//    private func processSelection(_ item: PhotosPickerItem) async {
//        isProcessing = true
//        defer { isProcessing = false; selectedItem = nil }
//
//        // 1. Извлекаем Data асинхронно через Transferable
//        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//
//        // 2. Создаем модель SwiftData (путь и ID)
//        let newMedia = MediaItem(fileName: "upload", fileExtension: "jpg")
//
//        do {
//            // 3. Сохраняем файл на диск через наш актор
//            try await MediaStorageService().saveImage(data: data, for: newMedia)
//
//            // 4. Вставляем в контекст SwiftData
//            modelContext.insert(newMedia)
//
//            // Если вы вставляете это в конкретный объект (например, Post):
//            // currentPost.photos.append(newMedia)
//
//        } catch {
//            print("Ошибка сохранения: \(error)")
//        }
//    }
//}
