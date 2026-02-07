//
//  MediaDTO.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

struct MediaDTO: Sendable, Identifiable {
    let id: PersistentIdentifier
    let fileName: String
    let fileExtension: String
    let type: String
    let data: Data
    let thumbnailData: Data
    let createdAt: Date

    init(from model: MediaModel) {
        id = model.persistentModelID
        fileName = model.fileName ?? ""
        fileExtension = model.fileExtension ?? ""
        type = model.type ?? ""
        data = model.data ?? Data()
        thumbnailData = model.thumbnailData ?? Data()
        createdAt = model.createdAt ?? .now
    }
}
