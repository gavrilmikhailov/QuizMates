import ProjectDescription

let versionNumber = "1.0"
let buildNumber = "9"
let teamId = "6PWFL227LZ"
let deploymentTarget = "17.0"
let bundleId = "gmikay.quiz.mates"
let name = "Quiz Mates"
let swiftVersion = "6.2.3"

let coreModule = Target.target(
    name: "CoreModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.core-module",
    deploymentTargets: .iOS(deploymentTarget),
    sources: "Targets/CoreModule/Sources/**"
)
let navigationModule = Target.target(
    name: "NavigationModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.navigation-module",
    deploymentTargets: .iOS(deploymentTarget),
    sources: "Targets/NavigationModule/Sources/**",
    dependencies: [.external(name: "Swinject", condition: nil)]
)
let databaseModule = Target.target(
    name: "DatabaseModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.database-module",
    deploymentTargets: .iOS(deploymentTarget),
    sources: .paths(["Targets/DatabaseModule/Sources/**"]),
    dependencies: [
        .external(name: "Swinject", condition: nil)
    ]
)
let questionsGridModule = Target.target(
    name: "QuestionsGridModule",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "gmikay.quiz.mates.questions-grid-module",
    deploymentTargets: .iOS(deploymentTarget),
    sources: .paths(["Targets/QuestionsGridModule/Sources/**"]),
    resources: .resources(["Targets/QuestionsGridModule/Resources/**"]),
    dependencies: [
        .external(name: "Swinject", condition: nil),
        .external(name: "DeviceKit", condition: nil),
        .external(name: "Vortex", condition: nil),
        .target(name: "DatabaseModule", condition: nil),
        .target(name: "NavigationModule", condition: nil),
        .target(name: "CoreModule", condition: nil)
    ]
)

let unitTests = Target.target(
    name: "UnitTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "gmikay.quiz.mates.unit-tests",
    deploymentTargets: .iOS(deploymentTarget),
    sources: .paths(["Targets/UnitTests/**"])
)

let uiTests = Target.target(
    name: "UITests",
    destinations: .iOS,
    product: .uiTests,
    bundleId: "gmikay.quiz.mates.ui-tests",
    deploymentTargets: .iOS(deploymentTarget),
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
        .target(name: "QuestionsGridModule", condition: nil),
        .target(name: "DatabaseModule", condition: nil),
        .target(name: "NavigationModule", condition: nil),
        .target(name: "CoreModule", condition: nil)
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
    targets: [coreModule, navigationModule, databaseModule, questionsGridModule, unitTests, uiTests, mainApp],
    resourceSynthesizers: [.assets(), .strings(), .fonts()]
)
