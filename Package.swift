// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Substate",

    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],

    products: [
        .library(name: "Substate", targets: ["Substate"]),
        .library(name: "SubstateUI", targets: ["SubstateUI"]),
        .library(name: "SubstateMiddleware", targets: ["SubstateMiddleware"]),
        .library(name: "Package", targets: ["Substate", "SubstateMiddleware", "SubstateUI"]),
    ],

    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime", from: "2.2.4"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],

    targets: [
        .target (
            name: "Substate",
            dependencies: ["Runtime"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks"
                ])
            ]
        ),

        .target (
            name: "SubstateUI",
            dependencies: ["Substate"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks"
                ])
            ]
        ),

        .target (
            name: "SubstateMiddleware",
            dependencies: ["Substate"],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                    "-Xfrontend", "-enable-actor-data-race-checks"
                ])
            ]
        ),

        .testTarget(name: "SubstateTests", dependencies: ["Substate", "SubstateMiddleware"]),
        .testTarget(name: "SubstateUITests", dependencies: ["Substate", "SubstateUI"]),
        .testTarget(name: "SubstateMiddlewareTests", dependencies: ["Substate", "SubstateMiddleware"]),
    ]
)
