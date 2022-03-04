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
        .package(url: "https://github.com/wickwirew/Runtime", from: "2.2.4")
    ],

    targets: [
        .target(name: "Substate", dependencies: ["Runtime"]),
        .target(name: "SubstateUI", dependencies: ["Substate"]),
        .target(name: "SubstateMiddleware", dependencies: ["Substate"]),

        .testTarget(name: "SubstateTests", dependencies: ["Substate", "SubstateMiddleware"]),
        .testTarget(name: "SubstateUITests", dependencies: ["Substate", "SubstateUI"]),
        .testTarget(name: "SubstateMiddlewareTests", dependencies: ["Substate", "SubstateMiddleware"]),
    ]
)
