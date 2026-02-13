//
//  QuestionEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import PhotosUI
import SwiftUI

@MainActor
protocol QuestionEditorDelegate: AnyObject {
    func didSubmitNewQuestion(
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    )
    func didSubmitUpdatedQuestion(question: QuestionDTO, medias: [MediaDraft],)
    func didDeleteQuestion(question: QuestionDTO)
}

@MainActor
protocol QuestionEditorViewControllerProtocol: AnyObject {
    func displayQuestionContent(
        isInitial: Bool,
        medias: [MediaDTO],
        mediaDrafts: [MediaDraft],
        text: String,
        answer: String,
        price: Int
    )
    func displayUpdateContent()
    func displaySubmitNewQuestion(
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    )
    func displaySubmitUpdatedQuestion(question: QuestionDTO, medias: [MediaDraft])
    func displayDeleteQuestion(question: QuestionDTO)
    func displayError(text: String)
}

final class QuestionEditorViewController: UIHostingController<QuestionEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    var onOpenMediaPreview: ((MediaPreviewConfiguration) -> Void)?
    weak var delegate: QuestionEditorDelegate?

    // MARK: - Private properties

    private let interactor: QuestionEditorInteractorProtocol
    private let viewModel: QuestionEditorViewModel
    private let isNew: Bool

    // MARK: - Initializer

    init(
        interactor: QuestionEditorInteractorProtocol,
        viewModel: QuestionEditorViewModel,
        isNew: Bool,
        rootView: QuestionEditorView
    ) {
        self.interactor = interactor
        self.viewModel = viewModel
        self.isNew = isNew
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        interactor.loadQuestionContent(isInitial: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private methods

    private func configureAppearance() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = isNew
        title = isNew ? Strings.newQuestion : ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        if isNew {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        }
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: Strings.deleteQuestionTitle,
            message: Strings.deleteQuestionWarning,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: Strings.deleteQuestionAction, style: .destructive) { [weak self] _ in
            self?.interactor.deleteQuestion()
        }
        let cancelAction = UIAlertAction(title: Strings.deleteQuestionCancel, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }

    @objc
    private func saveButtonTapped() {
        interactor.submitQuestion(
            text: viewModel.questionText,
            answer: viewModel.questionAnswer,
            price: viewModel.questionPrice
        )
    }
}

// MARK: - QuestionEditorViewControllerProtocol

extension QuestionEditorViewController: QuestionEditorViewControllerProtocol {

    func displayQuestionContent(
        isInitial: Bool,
        medias: [MediaDTO],
        mediaDrafts: [MediaDraft],
        text: String,
        answer: String,
        price: Int
    ) {
        if isInitial {
            viewModel.medias = medias
            viewModel.mediaDrafts = mediaDrafts
        } else {
            withAnimation {
                viewModel.medias = medias
                viewModel.mediaDrafts = mediaDrafts
            }
        }
        viewModel.questionText = text
        viewModel.questionAnswer = answer
        viewModel.questionPrice = price
        viewModel.photoPickerItems = []
        viewModel.videoPickerItems = []
    }

    func displayUpdateContent() {
        interactor.updateQuestionContent(
            text: viewModel.questionText,
            answer: viewModel.questionAnswer,
            price: viewModel.questionPrice
        )
    }

    func displaySubmitNewQuestion(
        question: QuestionDraft,
        medias: [MediaDraft],
        topic: TopicDTO
    ) {
        delegate?.didSubmitNewQuestion(question: question, medias: medias, topic: topic)
        onClose?()
    }

    func displaySubmitUpdatedQuestion(question: QuestionDTO, medias: [MediaDraft]) {
        delegate?.didSubmitUpdatedQuestion(question: question, medias: medias)
        onClose?()
    }

    func displayDeleteQuestion(question: QuestionDTO) {
        delegate?.didDeleteQuestion(question: question)
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: Strings.errorTitle, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.errorAction, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionEditorViewDelegate

extension QuestionEditorViewController: QuestionEditorViewDelegate {

    func didPickMediaItems(items: [PhotosPickerItem]) {
        interactor.addMediaItems(items: items)
    }

    func didPickMediaItems(images: [URL]) {
        interactor.addMediaItems(images: images)
    }

    func didPickMediaItems(audios: [URL]) {
        interactor.addMediaItems(audios: audios)
    }

    func didTapMedia(media: MediaDTO) {
        let configuration = MediaPreviewConfiguration(
            fileName: media.fileName,
            fileExtension: media.fileExtension,
            type: media.type,
            data: media.data
        )
        onOpenMediaPreview?(configuration)
    }

    func didTapMedia(draft: MediaDraft) {
        let configuration = MediaPreviewConfiguration(
            fileName: draft.fileName,
            fileExtension: draft.fileExtension,
            type: draft.type,
            data: draft.data
        )
        onOpenMediaPreview?(configuration)
    }

    func didTapDeleteMedia(fileName: String) {
        interactor.deleteMedia(fileName: fileName)
    }
}

// MARK: - MediaPreviewDelegate

extension QuestionEditorViewController: MediaPreviewDelegate {

    func didDeleteMedia(fileName: String) {
        interactor.deleteMedia(fileName: fileName)
    }
}
