// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Substate",

    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],

    products: [
        .library(name: "Substate", targets: ["Substate"]),
        .library(name: "SubstateExample", targets: ["SubstateExample"]),
        .library(name: "SubstateMiddleware", targets: ["SubstateMiddleware"]),
    ],

    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime", from: "2.2.2"),
    ],

    targets: [
        .target(name: "Substate", dependencies: ["Runtime"]),
        .target(name: "SubstateExample", dependencies: ["Substate"]),
        .target(name: "SubstateMiddleware", dependencies: ["Substate"]),

        .testTarget(name: "SubstateTests", dependencies: ["Substate"]),
    ]
)
