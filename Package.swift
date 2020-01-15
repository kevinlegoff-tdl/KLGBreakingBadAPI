// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KLBreakingBadAPI",
    products: [
        .library(
            name: "KLBreakingBadAPI",
            targets: ["KLBreakingBadAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KLBreakingBadAPI",
            dependencies: []),
        .testTarget(
            name: "KLBreakingBadAPITests",
            dependencies: ["KLBreakingBadAPI"]),
    ]
)
