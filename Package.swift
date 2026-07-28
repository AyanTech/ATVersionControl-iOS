// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATVersionControl",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "ATVersionControl",
            targets: ["ATVersionControl"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AyanTech/SwiftBooster", .branch("master")),
        .package(url: "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS", .upToNextMajor(from: "1.8.0")),
    ],
    targets: [
        .target(
            name: "ATVersionControl",
            dependencies: [
                .product(name: "AyanTechNetworkingLibrary", package: "AyanTechNetworkingLibrary-iOS"),
                "SwiftBooster"
            ],
            path: "ATVersionControl"
        ),
    ]
)
