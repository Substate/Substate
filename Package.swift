// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Substate",

    platforms: [
        .iOS(.v14), .macOS(.v10_15)
    ],

    products: [
        .library(name: "Substate", targets: ["Substate"]),
        .library(name: "SubstateMiddleware", targets: ["SubstateMiddleware"]),
        .library(name: "SubstateUI", targets: ["SubstateUI"]),
        .library(name: "Package", targets: ["Substate", "SubstateMiddleware", "SubstateUI"]),
    ],

    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime", from: "2.2.2"),
    ],

    targets: [
        .target(name: "Substate", dependencies: ["Runtime"]),
        .target(name: "SubstateMiddleware", dependencies: ["Substate"]),
        .target(name: "SubstateUI", dependencies: ["Substate"]),

        .testTarget(name: "SubstateTests", dependencies: ["Substate"]),
        .testTarget(name: "SubstateMiddlewareTests", dependencies: ["Substate", "SubstateMiddleware"]),
    ]
)
