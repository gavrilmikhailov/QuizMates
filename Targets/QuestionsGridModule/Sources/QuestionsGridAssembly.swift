//
//  QuestionsGridAssembly.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 22.01.2026.
//

import DatabaseModule
import SwiftData
@preconcurrency import Swinject
import UserDefaultsModule

public final class QuestionsGridAssembly: Assembly {

    // MARK: - Initializer

    public init() {}

    // MARK: - Assembly

    public func assemble(container: Container) {
        MainActor.assumeIsolated {
            container.register(GamesListViewController.self) { resolver in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let presenter = GamesListPresenter()
                let interactor = GamesListInteractor(
                    presenter: presenter,
                    databaseService: databaseService
                )
                let viewModel = GamesListViewModel()
                let view = GamesListViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GamesListView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // New game
            container.register(GameEditorViewController.self) { resolver in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let presenter = GameEditorPresenter()
                let interactor = GameEditorInteractor(
                    presenter: presenter,
                    databaseSevice: databaseService,
                    game: nil
                )
                let viewModel = GameEditorViewModel()
                let view = GameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // Edit game
            container.register(GameEditorViewController.self) { (resolver: Resolver, game: GameDTO) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let presenter = GameEditorPresenter()
                let interactor = GameEditorInteractor(
                    presenter: presenter,
                    databaseSevice: databaseService,
                    game: game
                )
                let viewModel = GameEditorViewModel()
                let view = GameEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GameEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                presenter.view = view
                return view
            }
            // New topic
            container.register(TopicEditorViewController.self) { (resolver: Resolver, game: GameDTO) in
                let interactor = TopicEditorInteractor(
                    game: game,
                    mode: .createNewTopic(TopicDraft(name: "", createdAt: .now))
                )
                let viewModel = TopicEditorViewModel()
                let view = TopicEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: true,
                    rootView: TopicEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Edit topic
            container.register(TopicEditorViewController.self) { (resolver: Resolver, game: GameDTO, topic: TopicDTO) in
                let interactor = TopicEditorInteractor(
                    game: game,
                    mode: .editExistingTopic(topic)
                )
                let viewModel = TopicEditorViewModel(name: topic.name)
                let view = TopicEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: false,
                    rootView: TopicEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // New Question
            container.register(QuestionEditorViewController.self) { (resolver: Resolver, topic: TopicDTO) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let interactor = QuestionEditorInteractor(
                    databaseService: databaseService,
                    topic: topic,
                    mode: .createNewQuestion(
                        QuestionDraft(text: "", answer: "", price: 100, isAnswered: false)
                    )
                )
                let viewModel = QuestionEditorViewModel()
                let view = QuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: true,
                    rootView: QuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Edit Question
            container.register(QuestionEditorViewController.self) { (resolver: Resolver, topic: TopicDTO, question: QuestionDTO) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let interactor = QuestionEditorInteractor(
                    databaseService: databaseService,
                    topic: topic,
                    mode: .editExistingQuestion(question)
                )
                let viewModel = QuestionEditorViewModel(
                    questionText: question.text,
                    questionAnswer: question.answer,
                    questionPrice: question.price
                )
                let view = QuestionEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    isNew: false,
                    rootView: QuestionEditorView(viewModel: viewModel)
                )
                view.rootView.delegate = view
                interactor.view = view
                return view
            }
            // Photo preview
            container.register(MediaPreviewViewController.self) { (resolver: Resolver, configuration: MediaPreviewConfiguration) in
                let view = MediaPreviewViewController(
                    fileName: configuration.fileName,
                    rootView: MediaPreviewView(configuration: configuration)
                )
                return view
            }
            // New player
            container.register(PlayerEditorViewController.self) { (resolver: Resolver, game: GameDTO) in
                let mode: PlayerEditorMode = .createNewPlayer(
                    PlayerDraft(emoji: "", name: "", createdAt: .now)
                )
                let interactor = PlayerEditorInteractor(game: game, mode: mode)
                let viewModel = PlayerEditorViewModel()
                let view = PlayerEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    mode: mode,
                    rootView: PlayerEditorView(viewModel: viewModel)
                )
                interactor.view = view
                view.rootView.delegate = view
                return view
            }
            // Edit player
            container.register(PlayerEditorViewController.self) { (resolver: Resolver, game: GameDTO, player: PlayerDTO) in
                let mode: PlayerEditorMode = .editExistingPlayer(player)
                let interactor = PlayerEditorInteractor(game: game, mode: mode)
                let viewModel = PlayerEditorViewModel()
                let view = PlayerEditorViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    mode: mode,
                    rootView: PlayerEditorView(viewModel: viewModel)
                )
                interactor.view = view
                view.rootView.delegate = view
                return view
            }
            // Game process
            container.register(GameProcessViewController.self) { (resolver: Resolver, game: GameDTO) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let userDefaultsService = resolver.resolve(UserDefaultsServiceProtocol.self)!
                let viewModel = GameProcessViewModel()
                let interactor = GameProcessInteractor(
                    databaseSevice: databaseService,
                    userDefaultsService: userDefaultsService,
                    game: game
                )
                let view = GameProcessViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GameProcessView(viewModel: viewModel)
                )
                interactor.view = view
                view.rootView.delegate = view
                return view
            }
            // Game process question
            container.register(GameProcessQuestionViewController.self) { (resolver: Resolver, topic: TopicDTO, question: QuestionDTO, players: [PlayerDTO]) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let viewModel = GameProcessQuestionViewModel()
                let interactor = GameProcessQuestionInteractor(
                    databaseService: databaseService,
                    topic: topic,
                    question: question,
                    players: players
                )
                let view = GameProcessQuestionViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GameProcessQuestionView(viewModel: viewModel)
                )
                interactor.view = view
                view.rootView.delegate = view
                return view
            }
            // Game process settings
            container.register(GameProcessSettingsViewController.self) { (resolver: Resolver, configuration: GameProcessSettingsConfiguration, delegate: GameProcessSettingsDelegate?) in
                let view = GameProcessSettingsViewController(
                    rootView: GameProcessSettingsView(configuration: configuration, delegate: delegate)
                )
                return view
            }
            // Game results
            container.register(GameResultsViewController.self) { (resolver: Resolver, players: [PlayerDTO]) in
                let databaseService = resolver.resolve(DatabaseServiceProtocol.self)!
                let viewModel = GameResultsViewModel()
                let interactor = GameResultsInteractor(databaseService: databaseService, players: players)
                let view = GameResultsViewController(
                    interactor: interactor,
                    viewModel: viewModel,
                    rootView: GameResultsView(viewModel: viewModel)
                )
                interactor.view = view
                view.rootView.delegate = view
                return view
            }
            // Birthday
            container.register(BirthdayViewController.self) { _ in
                let viewModel = BirthdayViewModel()
                let view = BirthdayViewController(
                    viewModel: viewModel,
                    rootView: BirthdayView(viewModel: viewModel)
                )
                return view
            }
        }
    }
}
