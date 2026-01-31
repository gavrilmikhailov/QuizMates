//
//  QuestionsGridAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import SwiftData
@preconcurrency import Swinject

final class QuestionsGridAssembly: Assembly {

    // MARK: - Assembly

    func assemble(container: Container) {
        MainActor.assumeIsolated {
            container.register(QuestionsGridGamesListViewController.self) { resolver in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let mediaStorageService = resolver.resolve(MediaStorageService.self)!
                let presenter = QuestionsGridGamesListPresenter()
                let interactor = QuestionsGridGamesListInteractor(
                    presenter: presenter,
                    databaseService: databaseService,
                    mediaStorageService: mediaStorageService
                )
                let viewModel = QuestionsGridGamesListViewModel()
                let view = QuestionsGridGamesListViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGamesListView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // New game
            container.register(QuestionsGridGameEditorViewController.self) { resolver in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let presenter = QuestionsGridGameEditorPresenter()
                let interactor = QuestionsGridGameEditorInteractor(
                    presenter: presenter,
                    databaseSevice: databaseService,
                    game: nil
                )
                let viewModel = QuestionsGridGameEditorViewModel()
                let view = QuestionsGridGameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // Edit game
            container.register(QuestionsGridGameEditorViewController.self) { (resolver: Resolver, game: QuestionsGridGameDTO) in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let presenter = QuestionsGridGameEditorPresenter()
                let interactor = QuestionsGridGameEditorInteractor(
                    presenter: presenter,
                    databaseSevice: databaseService,
                    game: game
                )
                let viewModel = QuestionsGridGameEditorViewModel()
                let view = QuestionsGridGameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: QuestionsGridGameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // New topic
            container.register(QuestionsGridTopicEditorViewController.self) { (resolver: Resolver, game: QuestionsGridGameDTO) in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let interactor = QuestionsGridTopicEditorInteractor(
                    databaseService: databaseService,
                    game: game,
                    mode: .createNewTopic(QuestionsGridTopicDraft(name: "", createdAt: .now))
                )
                let viewModel = QuestionsGridTopicEditorViewModel()
                let view = QuestionsGridTopicEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: true,
                    rootView: QuestionsGridTopicEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Edit topic
            container.register(QuestionsGridTopicEditorViewController.self) { (resolver: Resolver, game: QuestionsGridGameDTO, topic: QuestionsGridTopicDTO) in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let interactor = QuestionsGridTopicEditorInteractor(
                    databaseService: databaseService,
                    game: game,
                    mode: .editExistingTopic(topic)
                )
                let viewModel = QuestionsGridTopicEditorViewModel(name: topic.name)
                let view = QuestionsGridTopicEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: false,
                    rootView: QuestionsGridTopicEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // New Question
            container.register(QuestionsGridQuestionEditorViewController.self) { (resolver: Resolver, topic: QuestionsGridTopicDTO) in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let mediaStorageService = resolver.resolve(MediaStorageService.self)!
                let interactor = QuestionsGridQuestionEditorInteractor(
                    databaseService: databaseService,
                    mediaStorageService: mediaStorageService,
                    topic: topic,
                    mode: .createNewQuestion(
                        QuestionsGridQuestionDraft(text: "", answer: "", price: 50, isAnswered: false)
                    )
                )
                let viewModel = QuestionsGridQuestionEditorViewModel()
                let view = QuestionsGridQuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: true,
                    rootView: QuestionsGridQuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Edit Question
            container.register(QuestionsGridQuestionEditorViewController.self) { (resolver: Resolver, topic: QuestionsGridTopicDTO, question: QuestionsGridQuestionDTO) in
                let databaseService = resolver.resolve(DatabaseService.self)!
                let mediaStorageService = resolver.resolve(MediaStorageService.self)!
                let interactor = QuestionsGridQuestionEditorInteractor(
                    databaseService: databaseService,
                    mediaStorageService: mediaStorageService,
                    topic: topic,
                    mode: .editExistingQuestion(question)
                )
                let viewModel = QuestionsGridQuestionEditorViewModel(
                    questionText: question.text,
                    questionAnswer: question.answer,
                    questionPrice: question.price
                )
                let view = QuestionsGridQuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: false,
                    rootView: QuestionsGridQuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Photo preview
            container.register(QuestionsGridMediaPreviewViewController.self) { (resolver: Resolver, mode: QuestionsGridMediaPreviewMode) in
                let url = switch mode {
                case .media(let dto):
                    dto.localURL
                case .mediaDraft(let draft):
                    draft.localURL
                }
                let type = switch mode {
                case .media(let dto):
                    dto.type
                case .mediaDraft(let draft):
                    draft.type
                }
                let view = QuestionsGridMediaPreviewViewController(
                    mode: mode,
                    rootView: QuestionsGridMediaPreviewView(url: url, type: type)
                )
                return view
            }
            // New player
            container.register(QuestionsGridPlayerEditorViewController.self) { (resolver: Resolver, game: QuestionsGridGameDTO) in
                let viewModel = QuestionsGridPlayerEditorViewModel()
                let view = QuestionsGridPlayerEditorViewController(
                    viewModel: viewModel,
                    mode: .createNewPlayer(QuestionsGridPlayerDraft(name: "", order: 0)),
                    rootView: QuestionsGridPlayerEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                return view
            }
            // Edit player
            container.register(QuestionsGridPlayerEditorViewController.self) { (resolver: Resolver, game: QuestionsGridGameDTO, player: QuestionsGridPlayerDTO) in
                let viewModel = QuestionsGridPlayerEditorViewModel()
                let view = QuestionsGridPlayerEditorViewController(
                    viewModel: viewModel,
                    mode: .editExistingPlayer(player),
                    rootView: QuestionsGridPlayerEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                return view
            }
        }
    }
}
