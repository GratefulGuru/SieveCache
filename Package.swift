// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SieveCache",
    products: [
        .library(
            name: "SieveCache",
            targets: ["SieveCache"]),
    ],
    targets: [
        .target(
            name: "SieveCache"),
        .testTarget(
            name: "SieveCacheTests",
            dependencies: ["SieveCache"]),
    ]
)
