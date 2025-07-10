// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YaSpellChecker",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "YaSpellChecker",
            targets: ["YaSpellChecker"]
        ),
        .executable(
            name: "ExampleApp",
            targets: ["ExampleApp"]
        )
    ],
    targets: [
        .target(
            name: "YaSpellChecker",
            resources: [
                .process("Localizable.xcstrings")
            ]
        ),
        .executableTarget(
            name: "ExampleApp",
            dependencies: ["YaSpellChecker"]
        ),
        .testTarget(
            name: "YaSpellCheckerTests",
            dependencies: ["YaSpellChecker"]
        )
    ]
)
