// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Vessel",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Vessel",
            targets: ["Vessel"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-http-types", from: "0.2.1")
    ],
    targets: [
        .target(
            name: "Vessel",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types")
            ]
        ),
        .testTarget(
            name: "VesselTests",
            dependencies: ["Vessel"]
        ),
    ]
)
