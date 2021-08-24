// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BRIck",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "BRIck",
            targets: ["BRIck"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BRIck",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                          ]
        ),
        .testTarget(
            name: "BRIckTests",
            dependencies: ["BRIck"]
        ),
    ]
)
