import PackageDescription

let package = Package(
    name: "WhiteDragon",
    products: [
        .library(
            name: "WhiteDragon",
            targets: ["WhiteDragon"]
        )
    ],
    targets: [
        .target(
            name: "WhiteDragon",
            path: "WhiteDragon/Classes"
        )
    ],
    swiftLanguageVersions: [
        4
    ]
)
