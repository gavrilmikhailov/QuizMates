//
//  QuestionsGridQuestionEditorViewModel.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import Observation
import PhotosUI
import SwiftUI

@Observable
final class QuestionsGridQuestionEditorViewModel {
    var medias: [QuestionsGridMediaDTO]
    var mediaDrafts: [QuestionsGridMediaDraft]
    var questionText: String
    var questionAnswer: String
    var questionPrice: Int
    var photoPickerItems: [PhotosPickerItem]
    var videoPickerItems: [PhotosPickerItem]

    init(
        medias: [QuestionsGridMediaDTO] = [],
        mediaDrafts: [QuestionsGridMediaDraft] = [],
        questionText: String = "",
        questionAnswer: String = "",
        questionPrice: Int = 50,
        photoPickerItems: [PhotosPickerItem] = [],
        videoPickerItems: [PhotosPickerItem] = []
    ) {
        self.medias = medias
        self.mediaDrafts = mediaDrafts
        self.questionText = questionText
        self.questionAnswer = questionAnswer
        self.questionPrice = questionPrice
        self.photoPickerItems = photoPickerItems
        self.videoPickerItems = videoPickerItems
    }
}
