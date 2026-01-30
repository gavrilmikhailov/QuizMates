//
//  QuestionsGridQuestionEditorViewController.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 24.01.2026.
//

import PhotosUI
import SwiftUI

@MainActor
protocol QuestionsGridQuestionEditorDelegate: AnyObject {
    func didSubmitNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    )
    func didSubmitUpdatedQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft],)
    func didDeleteQuestion(question: QuestionsGridQuestionDTO)
}

@MainActor
protocol QuestionsGridQuestionEditorViewControllerProtocol: AnyObject {
    func displayQuestionContent(
        medias: [QuestionsGridMediaDTO],
        mediaDrafts: [QuestionsGridMediaDraft],
        text: String,
        answer: String,
        price: Int
    )
    func displayUpdateContent()
    func displaySubmitNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    )
    func displaySubmitUpdatedQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft])
    func displayDeleteQuestion(question: QuestionsGridQuestionDTO)
    func displayError(text: String)
}

final class QuestionsGridQuestionEditorViewController: UIHostingController<QuestionsGridQuestionEditorView> {

    // MARK: - Internal properties

    var onClose: (() -> Void)?
    var onOpenPhotoPreview: ((QuestionsGridPhotoPreviewMode) -> Void)?
    weak var delegate: QuestionsGridQuestionEditorDelegate?

    // MARK: - Private properties

    private let interactor: QuestionsGridQuestionEditorInteractorProtocol
    private let viewModel: QuestionsGridQuestionEditorViewModel
    private let isNew: Bool

    // MARK: - Initializer

    init(
        interactor: QuestionsGridQuestionEditorInteractorProtocol,
        viewModel: QuestionsGridQuestionEditorViewModel,
        isNew: Bool,
        rootView: QuestionsGridQuestionEditorView
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
        interactor.loadQuestionContent()
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
        navigationController?.navigationBar.prefersLargeTitles = true
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
        title = "Новый вопрос"
    }

    @objc
    private func closeButtonTapped() {
        onClose?()
    }

    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Подтверждение",
            message: "Вы уверены, что хотите удалить этот вопрос?",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.interactor.deleteQuestion()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

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

// MARK: - QuestionsGridQuestionEditorViewControllerProtocol

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewControllerProtocol {

    func displayQuestionContent(
        medias: [QuestionsGridMediaDTO],
        mediaDrafts: [QuestionsGridMediaDraft],
        text: String,
        answer: String,
        price: Int
    ) {
        withAnimation {
            viewModel.medias = medias
            viewModel.mediaDrafts = mediaDrafts
        }
        viewModel.questionText = text
        viewModel.questionAnswer = answer
        viewModel.questionPrice = price
    }

    func displayUpdateContent() {
        interactor.updateQuestionContent(
            text: viewModel.questionText,
            answer: viewModel.questionAnswer,
            price: viewModel.questionPrice
        )
    }

    func displaySubmitNewQuestion(
        question: QuestionsGridQuestionDraft,
        medias: [QuestionsGridMediaDraft],
        topic: QuestionsGridTopicDTO
    ) {
        delegate?.didSubmitNewQuestion(question: question, medias: medias, topic: topic)
        onClose?()
    }

    func displaySubmitUpdatedQuestion(question: QuestionsGridQuestionDTO, medias: [QuestionsGridMediaDraft]) {
        delegate?.didSubmitUpdatedQuestion(question: question, medias: medias)
        onClose?()
    }

    func displayDeleteQuestion(question: QuestionsGridQuestionDTO) {
        delegate?.didDeleteQuestion(question: question)
        onClose?()
    }

    func displayError(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - QuestionsGridQuestionEditorViewDelegate

extension QuestionsGridQuestionEditorViewController: QuestionsGridQuestionEditorViewDelegate {

    func didPickPhoto(photo: PhotosPickerItem) {
        interactor.addPhoto(photo: photo)
    }

    func didTapPhoto(media: QuestionsGridMediaDTO) {
        onOpenPhotoPreview?(.media(media))
    }

    func didTapPhoto(draft: QuestionsGridMediaDraft) {
        onOpenPhotoPreview?(.mediaDraft(draft))
    }

    func didDeleteMedia(index: Int) {
        interactor.deleteMedia(index: index)
    }

    func didDeleteMediaDraft(index: Int) {
        interactor.deleteMediaDraft(index: index)
    }
}

// MARK: - QuestionsGridPhotoPreviewDelegate

extension QuestionsGridQuestionEditorViewController: QuestionsGridPhotoPreviewDelegate {

    func didDeletePhoto(mode: QuestionsGridPhotoPreviewMode) {
        interactor.deletePhoto(mode: mode)
    }
}
