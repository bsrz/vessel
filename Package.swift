// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Vessel",
    platforms: [.iOS(.v14), .macOS(.v11)],
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
