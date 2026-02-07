//
//  MediaModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation
import SwiftData

@Model
public final class MediaModel {
    var fileName: String?
    var fileExtension: String?
    var type: String?
    var createdAt: Date?

    @Attribute(.externalStorage)
    var data: Data?

    @Attribute(.externalStorage)
    var thumbnailData: Data?

    var question: QuestionModel?

    init(fileName: String, fileExtension: String, type: String, data: Data, thumbnailData: Data, createdAt: Date) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.type = type
        self.data = data
        self.thumbnailData = thumbnailData
        self.createdAt = createdAt
    }

    init(draft: MediaDraft) {
        self.fileName = draft.fileName
        self.fileExtension = draft.fileExtension
        self.type = draft.type
        self.createdAt = draft.createdAt
        self.data = draft.data
        self.thumbnailData = draft.thumbnailData
    }
}
