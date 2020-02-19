// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PnutSays",
    products: [
        .executable(name: "pnutsays", targets: ["PnutSays"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0")
    ],
    targets: [
        .target(name: "PnutSays", dependencies: ["SPMUtility"])
    ]
)
