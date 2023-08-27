// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Vessel",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "Vessel",
            targets: ["Vessel"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Vessel",
            dependencies: []
        ),
        .testTarget(
            name: "VesselTests",
            dependencies: ["Vessel"]
        ),
    ]
)
