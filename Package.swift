// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATVersionControl",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "ATVersionControl",
            targets: ["ATVersionControl"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sepbehroozi/SwiftBooster.git", .branch("main")),
        .package(url: "https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS", .branch("main")),
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
