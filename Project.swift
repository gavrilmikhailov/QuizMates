import ProjectDescription

let versionNumber = "1.0"
let buildNumber = "4"
let teamId = "6PWFL227LZ"
let deploymentTarget = "17.0"
let bundleId = "gmikay.quiz.mates"
let name = "Quiz Mates"
let swiftVersion = "6.2.3"

let databaseService = Target.target(
    name: "DatabaseService",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.database-service",
    sources: .paths(["Targets/DatabaseService/Sources/**"]),
    dependencies: [
        .external(name: "Swinject", condition: nil)
    ]
)

let questionsGrid = Target.target(
    name: "QuestionsGrid",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.questions-grid",
    sources: .paths(["Targets/QuestionsGrid/Sources/**"]),
    resources: .resources(["Targets/QuestionsGrid/Resources/**"]),
    dependencies: [
        .external(name: "Swinject", condition: nil),
        .external(name: "DeviceKit", condition: nil),
        .target(name: "DatabaseService", condition: nil)
    ]
)

let unitTests = Target.target(
    name: "UnitTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "gmikay.quiz.mates.unit-tests",
    sources: .paths(["Targets/UnitTests/**"])
)

let uiTests = Target.target(
    name: "UITests",
    destinations: .iOS,
    product: .uiTests,
    bundleId: "gmikay.quiz.mates.ui-tests",
    sources: .paths(["Targets/UITests/**"])
)

let mainApp = Target.target(
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
            ),
            "CFBundlePackageType": "APPL",
            "UIBackgroundModes": .array([.string("remote-notification")]),
            "ITSAppUsesNonExemptEncryption": .boolean(false)
        ]
    ),
    sources: .paths(["Targets/MainApp/Sources/**"]),
    resources: .resources(
        ["Targets/MainApp/Resources/**"],
        privacyManifest: .privacyManifest(
            tracking: false,
            trackingDomains: [],
            collectedDataTypes: [],
            accessedApiTypes: []
        )
    ),
    entitlements: .dictionary(
        [
            "aps-environment" : .string("development"),
            "com.apple.developer.icloud-container-identifiers": .array([.string("iCloud.gmikay.quiz.mates")]),
            "com.apple.developer.icloud-services": .array([.string("CloudKit")])
        ]
    ),
    dependencies: [
        .external(name: "Swinject", condition: nil),
        .external(name: "DeviceKit", condition: nil),
        .target(name: "QuestionsGrid", condition: nil),
        .target(name: "DatabaseService", condition: nil)
    ],
    settings: .settings(
        base: SettingsDictionary()
            .marketingVersion(versionNumber)
            .currentProjectVersion(buildNumber)
            .swiftVersion(swiftVersion)
            .merging(
                [
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "ENABLE_GLOBAL_CONCURRENCY": true,
                    "ENABLE_NONISOLATED_NONSENDING_BY_DEFAULT": true
                ]
            ),
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
)

let project = Project(
    name: "QuizMates",
    targets: [databaseService, questionsGrid, unitTests, uiTests, mainApp],
    resourceSynthesizers: [.assets(), .strings(), .fonts()]
)
