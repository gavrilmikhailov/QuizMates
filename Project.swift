import ProjectDescription

let versionNumber = "1.0"
let buildNumber = "1"
let teamId = "6PWFL227LZ"
let deploymentTarget = "17.0"
let bundleId = "gmikay.quiz.mates"
let name = "Quiz Games"

let project = Project(
    name: "QuizMates",
    targets: [
        .target(
            name: "QuizMates",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS(deploymentTarget),
            infoPlist: .dictionary(
                [
                    "CFBundleDevelopmentRegion": .string("$(DEVELOPMENT_LANGUAGE)"),
                    "CFBundleExecutable": .string("$(EXECUTABLE_NAME)"),
                    "CFBundleIdentifier": .string("$(PRODUCT_BUNDLE_IDENTIFIER)"),
                    "CFBundleInfoDictionaryVersion": .string("6.0"),
                    "CFBundleName": .string(name),
                    "CFBundleDisplayName": .string(name),
                    "CFBundleShortVersionString": .string(versionNumber),
                    "CFBundleVersion": .string(buildNumber),
                    "UILaunchStoryboardName": .string("LaunchScreen"),
                    "UIApplicationSceneManifest": .dictionary(
                        [
                            "UIApplicationSupportsMultipleScenes": .boolean(false),
                            "UISceneConfigurations": .dictionary(
                                [
                                    "UIWindowSceneSessionRoleApplication": .array(
                                        [
                                            .dictionary(
                                                [
                                                    "UISceneConfigurationName": .string("Default Configuration"),
                                                    "UISceneDelegateClassName": .string("QuizMates.SceneDelegate")
                                                ]
                                            )
                                        ]
                                    )
                                ]
                            )
                        ]
                    ),
                    "UISupportedInterfaceOrientations": .array(
                        [
                            .string("UIInterfaceOrientationPortrait"),
                            .string("UIInterfaceOrientationLandscapeLeft"),
                            .string("UIInterfaceOrientationLandscapeRight")
                        ]
                    ),
                    "UISupportedInterfaceOrientations~ipad": .array(
                        [
                            .string("UIInterfaceOrientationPortrait"),
                            .string("UIInterfaceOrientationPortraitUpsideDown"),
                            .string("UIInterfaceOrientationLandscapeLeft"),
                            .string("UIInterfaceOrientationLandscapeRight")
                        ]
                    )
                ]
            ),
            sources: .paths(["QuizMates/Sources/**"]),
            resources: .resources(
                ["QuizMates/Resources/**"],
                privacyManifest: .privacyManifest(
                    tracking: false,
                    trackingDomains: [],
                    collectedDataTypes: [],
                    accessedApiTypes: []
                )
            ),
            dependencies: [
                .external(name: "Swinject", condition: nil)
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .marketingVersion(versionNumber)
                    .currentProjectVersion(buildNumber),
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: SettingsDictionary()
                            .automaticCodeSigning(devTeam: teamId)
                            .manualCodeSigning(
                                identity: "iPhone Developer",
                                provisioningProfileSpecifier: "Quiz Mates Dev"
                            )
                            .swiftCompilationMode(.singlefile)
                            .swiftOptimizationLevel(.oNone)
                    ),
                    .release(
                        name: "Release",
                        settings: SettingsDictionary()
                            .automaticCodeSigning(devTeam: teamId)
                            .manualCodeSigning(
                                identity: "iPhone Distribution",
                                provisioningProfileSpecifier: "Quiz Mates Prod"
                            )
                            .swiftCompilationMode(.wholemodule)
                            .swiftOptimizationLevel(.o)
                    )
                ]
            )
        ),
        .target(
            name: "QuizMatesTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "gmikay.quiz.mates.utests",
            sources: .paths(["QuizMatesTests/**"])
        ),
        .target(
            name: "QuizMatesUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "gmikay.quiz.mates.uitests",
            sources: .paths(["QuizMatesUITests/**"])
        )
    ],
    resourceSynthesizers: [
        .assets(),
        .strings(),
        .fonts()
    ]
)
