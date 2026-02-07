//
//  MediaDraft.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 25.01.2026.
//

import Foundation

struct MediaDraft: Sendable, Identifiable {
    let id: UUID
    let fileName: String
    let fileExtension: String
    let type: String
    let data: Data
    let thumbnailData: Data
    let createdAt: Date
}
