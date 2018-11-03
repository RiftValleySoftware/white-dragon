// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "WhiteDragon",
    products: [
        .library(
            name: "WhiteDragon",
            targets: ["WhiteDragon"]
        ),
    ],
    targets: [
        .target(
            name: "WhiteDragon",
            dependencies: [],
            path: "WhiteDragon/Classes"
        ),
        .testTarget(
            name: "WhiteDragonTests",
            dependencies: ["WhiteDragon"],
            path: "WhiteDragonTests"
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
