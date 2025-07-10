// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YaSpellChecker",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v10)
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
            name: "YaSpellChecker"
        ),
        .executableTarget(
            name: "ExampleApp",
            dependencies: ["YaSpellChecker"]
        )
    ]
)
