// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BRIck",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10),
    ],
    products: [
        .library(
            name: "BRIck",
            targets: ["BRIck"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BRIck",
            dependencies: []),
        .testTarget(
            name: "BRIckTests",
            dependencies: ["BRIck"]),
    ]
)
