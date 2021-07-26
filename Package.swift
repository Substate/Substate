// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Substate",

    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],

    products: [
        .library(name: "Substate", targets: ["Substate"]),
        .library(name: "SubstateMiddleware", targets: ["SubstateMiddleware"]),
        .library(name: "SubstateUI", targets: ["SubstateUI"]),
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
