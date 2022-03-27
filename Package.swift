// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Game",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15)],
    products: [
        .library(name: "Game", targets: ["Game"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "Game", dependencies: [.product(name: "DequeModule", package: "swift-collections")]),
        .testTarget(name: "GameTests", dependencies: ["Game"]),
    ],
    swiftLanguageVersions: [.v5]
)
