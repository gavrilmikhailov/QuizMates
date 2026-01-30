//
//  VideoFile.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 30.01.2026.
//

import SwiftUI
import PhotosUI

struct VideoFile: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            // Система дает нам временный URL (received.file)
            // Мы должны скопировать его в нашу временную папку, чтобы работать с ним
            let fileName = received.file.lastPathComponent
            let copy = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            if FileManager.default.fileExists(atPath: copy.path) {
                try? FileManager.default.removeItem(at: copy)
            }

            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}
